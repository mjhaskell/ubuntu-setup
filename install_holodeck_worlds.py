import holodeck

pkgs = holodeck.available_packages()
for pkg in pkgs:
    question = f'Do you want to install {pkg} package? (y/n): '
    ans = input(question).lower()

    if ans[0] == 'y':
        print('Installing package:', pkg)
        holodeck.install(pkg)
    else:
        print('Not installing package:', pkg)
