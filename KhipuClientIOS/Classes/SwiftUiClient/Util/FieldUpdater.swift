
struct FieldUpdater {
    var appendText: ((String) -> Void)? = nil
    var removeLastChar: (() -> Void)? = nil
    var clearText: (() -> Void)? = nil
    var setText: ((String) -> Void)? = nil
}
