import lldb
import re
import os
from functools import partial

def __lldb_init_module (debugger, dict):
    debugger.HandleCommand("type summary add -x \"^Eigen::Matrix<.*>$\" -F\
                           LLDB_Eigen_Pretty_Printer.eigen_matrix_print -p -r\
                          -w Eigen")
    # debugger.HandleCommand(
    #     "type synthetic add -x \"^Eigen::Matrix<.*>$\" "
    #     # "--python-class LLDB_Eigen_Pretty_Printer.MatrixBlockSyntheticProvider"
    #     "-l LLDB_Eigen_Pretty_Printer.MatrixBlockSyntheticProvider -w Eigen"
    # )
    # debugger.HandleCommand(
    #     "type synthetic add -x \"^Eigen::Matrix<.*>$\" "
    #     "-l LLDB_Eigen_Pretty_Printer.MatrixRowBlockProvider -w Eigen"
    # )
    debugger.HandleCommand(
        "type synthetic add -x \"^Eigen::Matrix<.*>$\" "
        "-l LLDB_Eigen_Pretty_Printer.MatrixSummaryProvider -w Eigen"
    )
    debugger.HandleCommand("type summary add -x \"^Eigen::Array<.*>$\" -F\
                           LLDB_Eigen_Pretty_Printer.eigen_array_print -p -r\
                          -w Eigen")
    debugger.HandleCommand("type summary add -x \"^Eigen::Quaternion<.*>$\" \
                           -F LLDB_Eigen_Pretty_Printer.eigen_quaternion_print\
                           -p -r -w Eigen")
    debugger.HandleCommand("type summary add -x \"^Eigen::SparseMatrix<.*>$\"\
                           -F\
                           LLDB_Eigen_Pretty_Printer.eigen_sparsematrix_print\
                           -p -r -w Eigen")
    debugger.HandleCommand("type category enable Eigen")

def evaluate_expression(valobj, expr):
    return valobj.GetProcess().GetSelectedThread().GetSelectedFrame().EvaluateExpression(expr)

def evaluate_at_index(valobj, index):
    return valobj.GetValueForExpressionPath("["+str(index)+"]")

class Printer:
    def __init__(self, data):
        self.data = data

    def evaluate_real(self, index):
        # return f"{evaluate_at_index(self.data, index).GetValue():.8g}"
        # return "%1.8e" % float(evaluate_at_index(self.data, index).GetValue())
        return "%1.8g" % float(evaluate_at_index(self.data, index).GetValue())

    def evaluate_bool(self, index):
        # return f"{evaluate_at_index(self.data, index).GetValueAsUnsigned():d}"
        return "%d" % evaluate_at_index(self.data, index).GetValueAsUnsigned()

    def evaluate_complex_double(self, index):
        val = \
        list(self.data.GetValueForExpressionPath("["+str(index)+"]._M_value").GetValue())
        val[-1] = 'j'
        for n in range(0, len(val)):
            if (val[n] == " "):
                del val[n]
                del val[n+1]
                if val[n+1] == "-":
                    del val[n]
                break
        val = complex("".join(val))

        return '{0:1.5e} {1} {2:1.5e}i'.format(val.real,\
                                               '+-'[val.imag < 0],\
                                               abs(val.imag))

    def evaluate_complex_int(self, index):
        # val = self.data.GetValueForExpressionPath("["+str(index)+"]")
        val = evaluate_at_index(self.data, index)
        real = val.GetValueForExpressionPath("._M_real").GetValueAsSigned()
        imag = val.GetValueForExpressionPath("._M_imag").GetValueAsSigned()
        val = real + imag * 1j

        return '{0:1.5e} {1} {2:1.5e}i'.format(val.real,\
                                               '+-'[val.imag < 0],\
                                               abs(val.imag))

    def evaluate_complex_bool(self, index):
        # val = self.data.GetValueForExpressionPath("["+str(index)+"]")
        val = evaluate_at_index(self.data, index)
        real = val.GetValueForExpressionPath("._M_real").GetValueAsUnsigned()
        imag = val.GetValueForExpressionPath("._M_imag").GetValueAsUnsigned()

        return '{0:d} + {1:d}i'.format(real, imag)

class Matrix(Printer):
    def __init__(self, variety, val):
        try:
            valtype = val.GetType()
            type_str = valtype.GetDirectBaseClassAtIndex(0).GetName()

            begin = "Eigen::"+variety+"<"
            complex_scalar = "std::complex<"
            bool_key = "bool"

            if (type_str.find(complex_scalar) >= 0):
                regex = re.compile(begin + complex_scalar + ".*>,.*>")
                is_complex = True

                if (type_str.find(begin + complex_scalar + bool_key) >= 0):
                    is_bool = True
                else:
                    is_bool = False

            else:
                regex = re.compile(begin+".*>")
                is_complex = False

                if (type_str.find(begin + bool_key) >= 0):
                    is_bool = True
                else:
                    is_bool = False

            self.variety = regex.findall(type_str)[0]
            m = self.variety[len(begin):-1]
            template_params = m.split(",")
            # template_params = [x.replace(">", "") for x in template_params]
            template_params = [x.replace(" ", "") for x in template_params]

            self.rows = int(template_params[1])
            if self.rows == -1:
                self.rows = val.GetValueForExpressionPath(".m_storage.m_rows").GetValueAsSigned()

            self.cols = int(template_params[2])
            if self.cols == -1:
                self.cols = val.GetValueForExpressionPath(".m_storage.m_cols").GetValueAsSigned()

            self.options = 0
            if len(template_params) > 3:
                self.options = int(template_params[3])

            self.rowMajor = (int(self.options) & 0x1)
            self.innerType = template_params[0]

            if int(template_params[1]) == -1 or int(template_params[2]) == -1:
                data = val.GetValueForExpressionPath(".m_storage.m_data")
            else:
                data = val.GetValueForExpressionPath(".m_storage.m_data.array")

            Printer.__init__(self, data)
            if is_complex:
                val = self.data.GetValueForExpressionPath("[0]")
                if val.GetValueForExpressionPath("._M_value").IsValid():
                    self.get = partial(Printer.evaluate_complex_double, self)
                elif val.GetValueForExpressionPath("._M_real").IsValid():
                    if is_bool:
                        self.get = partial(Printer.evaluate_complex_bool, self)
                    else:
                        self.get = partial(Printer.evaluate_complex_int, self)
                else:
                    self.variety = -1
            else:
                if is_bool:
                    self.get = partial(Printer.evaluate_bool, self)
                else:
                    self.get = partial(Printer.evaluate_real, self)

        except:
            self.variety = -1

    def to_string(self):
        padding = 1
        for i in range(0, self.rows * self.cols):
            padding = max(padding, len(str(self.get(i))))
        # padding = 1

        output = "rows: %d, cols: %d" % (self.rows, self.cols)
        return output

        # output = "rows: %d, cols: %d\n[" % (self.rows, self.cols)
        # if (self.options):
        #     for i in range(0, self.rows):
        #         if i!=0:
        #             output += " "
        #
        #         for j in range(0, self.cols):
        #             val = self.get(i*self.cols+j)
        #             if j!=0:
        #                 output += val.rjust(padding+2, ' ')
        #             else:
        #                 output += val.rjust(padding+1, ' ')
        #
        #         if i!=self.rows-1:
        #             output += ";\n"
        # else:
        #     for i in range(0, self.rows):
        #         if i!=0:
        #             output += " "
        #
        #         for j in range(0, self.cols):
        #             val = self.get(i+j*self.rows)
        #             if j!=0:
        #                 output += val.rjust(padding+2, ' ')
        #             else:
        #                 output += val.rjust(padding+1, ' ')
        #
        #         if i!=self.rows-1:
        #             output += ";\n"
        #
        # output+=" ]\n"
        #
        # return output

    def format_matrix_block(self):
        padding = 1
        for i in range(0, self.rows * self.cols):
            padding = max(padding, len(str(self.get(i))))

        output = "["
        if (self.options):
            for i in range(0, self.rows):
                if i != 0:
                    output += " "

                for j in range(0, self.cols):
                    val = self.get(i*self.cols + j)
                    if j != 0:
                        output += val.rjust(padding+2, ' ')
                    else:
                        output += val.rjust(padding+1, ' ')

                if i != self.rows - 1:
                    output += ";\n"
        else:
            for i in range(0, self.rows):
                if i != 0:
                    output += " "

                for j in range(0, self.cols):
                    val = self.get(i + j*self.rows)
                    if j != 0:
                        output += val.rjust(padding+2, ' ')
                    else:
                        output += val.rjust(padding+1, ' ')

                if i != self.rows - 1:
                    output += ";\n"

        output += " ]"
        return output

class MatrixSummaryProvider:
    def __init__(self, valobj, internal_dict):
        self.valobj = valobj
        self.matrix = Matrix("Matrix", valobj)  # Your existing Matrix class

    def num_children(self):
        return 0  # No children, everything is in the summary

    def get_child_at_index(self, index):
        return None

    def get_child_index(self, name):
        return -1

    def update(self):
        return False

    def has_children(self):
        return False

    def summary(self):
        # Returns a multi-line string, formatted row-by-row
        s = ""
        padding = 1
        for i in range(0, self.matrix.rows * self.matrix.cols):
            padding = max(padding, len(str(self.matrix.get(i))))

        s += "["
        for i in range(self.matrix.rows):
            row_str = ""
            for j in range(self.matrix.cols):
                if self.matrix.options:  # row-major
                    idx = i * self.matrix.cols + j
                else:  # column-major
                    idx = i + j * self.matrix.rows
                val = str(self.matrix.get(idx))
                if j != 0:
                    row_str += val.rjust(padding + 2)
                else:
                    row_str += val.rjust(padding + 1)
            if i != self.matrix.rows - 1:
                row_str += ";"
            s += "\n " + row_str
        s += "\n]"
        return s

class MatrixBlockSyntheticProvider:
    def __init__(self, valobj, internal_dict):
        self.valobj = valobj
        self.matrix = Matrix("Matrix", valobj)

    def num_children(self):
        return 1 if self.matrix.variety != -1 else 0

    def get_child_at_index(self, index):
        if index != 0:
            return None

    #     # Create an SBValue child without passing through expression parsing
    #     # We attach a dummy summary to display the formatted block
    #     child = self.valobj.CreateValueFromExpression("<matrix_block>", '""')
    #     child.SetSummary(self.matrix.format_matrix_block())
    #     return child
    #
    #
    # def get_child_index(self, name):
    #     return 0 if name == "<matrix_block>" else -1

        text = self.matrix.format_matrix_block()
        return self.valobj.CreateValueFromExpression("", '"' + text + '"')

    def get_child_index(self, name):
        return 0 if name == "matrix" else -1

    def update(self):
        return False

    def has_children(self):
        return True

class MatrixRowBlockProvider:
    def __init__(self, valobj, internal_dict):
        self.valobj = valobj
        self.matrix = Matrix("Matrix", valobj)

    def num_children(self):
        return self.matrix.rows if self.matrix.variety != -1 else 0

    def get_child_at_index(self, row_index):
        # Return one SBValue representing the row
        row_elements = []
        for col_index in range(self.matrix.cols):
            if self.matrix.options:  # row-major
                linear_index = row_index * self.matrix.cols + col_index
            else:  # column-major
                linear_index = row_index + col_index * self.matrix.rows
            val = self.matrix.get(linear_index)
            row_elements.append(val)

        # Build a string that looks like your original row
        padding = 1
        for i in range(self.matrix.rows * self.matrix.cols):
            padding = max(padding, len(str(self.matrix.get(i))))
        row_str = ""
        for j, val in enumerate(row_elements):
            if j != 0:
                row_str += str(val).rjust(padding + 2)
            else:
                row_str += str(val).rjust(padding + 1)
        if row_index != self.matrix.rows - 1:
            row_str += ";"

        # Make SBValue child with summary = row_str
        child = self.valobj.CreateValueFromExpression(f"[row {row_index}]", '""')
        child.SetSummary(row_str)
        return child

    def get_child_index(self, name):
        if name.startswith("[row "):
            try:
                return int(name.split()[1])
            except:
                return -1
        return -1

    def update(self):
        return False

    def has_children(self):
        return True

class SparseMatrix(Printer):
    def __init__(self, val):
        try:
            valtype = val.GetType()
            type_str = valtype.GetDirectBaseClassAtIndex(0).GetName()

            begin = "Eigen::SparseMatrix<"
            complex_scalar = "std::complex<"
            bool_key = "bool"

            if (type_str.find(complex_scalar)>=0):
                regex = re.compile(begin + complex_scalar + ".*>,.*>")
                is_complex = True

                if (type_str.find(begin + complex_scalar + bool_key) >= 0):
                    is_bool = True
                else:
                    is_bool = False
            else:
                regex = re.compile(begin+".*>")
                is_complex = False

                if (type_str.find(begin + bool_key) >= 0):
                    is_bool = True
                else:
                    is_bool = False

            self.variety = regex.findall(type_str)[0]

            m = self.variety[len(begin):-1]
            template_params = m.split(",")
            template_params = [x.replace(" ", "") for x in template_params]

            self.options = 0

            if len(template_params) > 1:
                self.options = int(template_params[1])

            self.rowMajor = (int(self.options) & 0x1)
            self.innerType = template_params[0]

            if self.rowMajor:
                self.rows = \
                val.GetValueForExpressionPath(".m_outerSize").GetValueAsSigned()
                self.cols = \
                val.GetValueForExpressionPath(".m_innerSize").GetValueAsSigned()
            else:
                self.rows = \
                val.GetValueForExpressionPath(".m_innerSize").GetValueAsSigned()
                self.cols = \
                val.GetValueForExpressionPath(".m_outerSize").GetValueAsSigned()

            self.outerStarts = val.GetValueForExpressionPath(".m_outerIndex")

            self.innerNNZs = []
            innerNNZs = val.GetValueForExpressionPath(".m_innerNonZeros")

            if (innerNNZs.GetValueAsSigned()):
                for k in range(0, self.rows if self.rowMajor else self.cols):
                    self.innerNNZs.append(evaluate_at_index(innerNNZs,
                                                            k).GetValueAsSigned())
            else:
                for k in range(0, self.rows if self.rowMajor else self.cols):
                    self.innerNNZs.append(evaluate_at_index(self.outerStarts,
                                                            k+1).GetValueAsSigned()
                                         - evaluate_at_index(self.outerStarts,
                                                            k).GetValueAsSigned())

            self.nonzeros = sum(self.innerNNZs)
            self.size = \
            val.GetValueForExpressionPath(".m_data.m_size").GetValueAsSigned()
            self.indices = val.GetValueForExpressionPath(".m_data.m_indices")

            data = val.GetValueForExpressionPath(".m_data.m_values")
            Printer.__init__(self, data)

            if is_complex:
                val = self.data.GetValueForExpressionPath("[0]")
                if val.GetValueForExpressionPath("._M_value").IsValid():
                    self.get = partial(Printer.evaluate_complex_double, self)
                elif val.GetValueForExpressionPath("._M_real").IsValid():
                    if is_bool:
                        self.get = partial(Printer.evaluate_complex_bool, self)
                    else:
                        self.get = partial(Printer.evaluate_complex_int, self)
                else:
                    self.variety = -1
            else:
                if is_bool:
                    self.get = partial(Printer.evaluate_bool, self)
                else:
                    self.get = partial(Printer.evaluate_real, self)
        except:
            self.variety = -1

    def to_string(self):
        padding = 1

        for i in range(0, self.size):
            padding = max(padding, len(str(self.get(i))))

        output = "rows: %d, cols: %d, nonzeros: %d\n{ " % (self.rows,
                                                           self.cols,
                                                           self.nonzeros)

        if (self.rowMajor):
            for i in range(0, self.rows):
                index = evaluate_at_index(self.outerStarts, \
                                          i).GetValueAsSigned()
                size = self.innerNNZs[i]

                for count in range(0, size):
                    j = evaluate_at_index(self.indices, \
                                          index+count).GetValueAsSigned()
                    output += "[%d, %d] =" % (i, j)
                    output += self.get(index+count).rjust(padding+1, ' ') + ", "
        else:
            rows = list()
            cols = list()
            vals = list()
            for j in range(0, self.cols):
                index = evaluate_at_index(self.outerStarts, \
                                          j).GetValueAsSigned()
                size = self.innerNNZs[j]

                for count in range(0, size):
                    i = evaluate_at_index(self.indices, \
                                          index+count).GetValueAsSigned()

                    val = self.get(index+count)
                    rows.append(i)
                    cols.append(j)
                    vals.append(val)

            indices = sorted(range(len(rows)), key=lambda k: rows[k])

            for index in indices:
                output += "[%d, %d] =" % (rows[index], cols[index])
                output += vals[index].rjust(padding+1, ' ') + ", "

        output += "\b\b }\n" if self.nonzeros else " }\n"

        return output


class Quaternion(Printer):
    def __init__(self, val):
        try:
            valtype = val.GetType()
            type_str = valtype.GetDirectBaseClassAtIndex(0).GetName()
            begin = "Eigen::Quaternion<"
            regex = re.compile(begin + ".*>")

            self.variety = regex.findall(type_str)[0]

            m = self.variety[len(begin):-1]
            template_params = m.split(",")
            template_params = [x.replace(" ", "") for x in template_params]

            self.options = 0

            if len(template_params) > 1:
                self.options = int(template_params[1])

            self.DontAlign = (int(self.options) & 0x2)
            self.innerType = template_params[0]

            data = val.GetValueForExpressionPath(".m_coeffs.m_storage.m_data.array")
            Printer.__init__(self, data)
            self.variety = "Quaternion"
            self.get = partial(Printer.evaluate_real, self)
        except:
            self.variety = -1

    def to_string(self):
        padding = 1
        for i in range(0, 4):
            padding = max(padding, len(str(self.get(i))))

        output ="{ [x] = " + self.get(0) + ", " + \
                  "[y] = " + self.get(1) + ", " + \
                  "[z] = " + self.get(2) + ", " + \
                  "[w] = " + self.get(3) + " }\n"

        return output


def eigen_matrix_print (valobj,internal_dict):

    # if valobj.GetType().IsReferenceType():
        # val = valobj.Dereference()
    # else:
        # val = valobj

    matrix = Matrix("Matrix", valobj)

    if (matrix.variety == -1):
        return ""
    else:
        return matrix.to_string()

def eigen_array_print (valobj,internal_dict):

    array = Matrix("Array", valobj)

    if (array.variety == -1):
        return ""
    else:
        return array.to_string()

def eigen_quaternion_print (valobj,internal_dict):

    quaternion = Quaternion(valobj)

    if (quaternion.variety == -1):
        return ""
    else:
        return quaternion.to_string()

def eigen_sparsematrix_print (valobj,internal_dict):

    sparsematrix = SparseMatrix(valobj)

    if (sparsematrix.variety == -1):
        return ""
    else:
        return sparsematrix.to_string()
