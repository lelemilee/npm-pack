import sys
import json

if __name__=="__main__":
    pf = sys.argv[1] if len(sys.argv) >= 2 else "./package-lock.json"
    with open(pf) as f:
        package_lock = json.load(f)

    if "dependencies" not in package_lock:
        print("There are no dependencies in package-lock.json!")
        sys.exit(1)
    dev_deps = list(package_lock["devDependencies"].items()) if "devDependencies" in package_lock else []
    all_deps = list(package_lock["dependencies"].items()) + dev_deps
    deps=["{}@{}".format(k, v["version"]) for k,v in all_deps]
    deps.sort()

    print(" ".join(deps))
