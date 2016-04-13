func unwrap<T1, T2>(optional1: T1?, _ optional2: T2?) -> (T1, T2)? {
    switch (optional1, optional2) {
    case let (.Some(value1), .Some(value2)):
        return (value1, value2)
    default:
        return nil
    }
}

func unwrap<T1, T2, T3>(optional1: T1?, _ optional2: T2?, _ optional3: T3?) -> (T1, T2, T3)? {
    switch (optional1, optional2, optional3) {
    case let (.Some(value1), .Some(value2), .Some(value3)):
        return (value1, value2, value3)
    default:
        return nil
    }
}

func unwrap<T1, T2, T3, T4>(optional1: T1?, _ optional2: T2?, _ optional3: T3?, _ optional4: T4?) -> (T1, T2, T3, T4)? {
    switch (optional1, optional2, optional3, optional4) {
    case let (.Some(value1), .Some(value2), .Some(value3), .Some(value4)):
        return (value1, value2, value3, value4)
    default:
        return nil
    }
}