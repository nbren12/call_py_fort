# This code only runs once at the initialization you can e.g. load an ML model
# from a file here
print("I am at the module scope.")

def function(STATE):
    count = STATE.get("count", 0)
    # this code runs every function call
    print(f"function call_count {count}")
    STATE["count"] = count + 1

