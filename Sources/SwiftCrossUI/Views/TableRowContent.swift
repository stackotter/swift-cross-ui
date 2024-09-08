public protocol TableRowContent<RowValue> {
    associatedtype RowValue
    associatedtype RowContent: View

    var labels: [String] { get }

    func content(for row: RowValue) -> RowContent
}

public struct EmptyTableRowContent<RowValue>: TableRowContent {
    public typealias RowContent = EmptyView

    public var labels: [String] {
        []
    }

    public init() {}

    public func content(for row: RowValue) -> EmptyView {
        EmptyView()
    }
}

public struct TupleTableRowContent1<
    RowValue,
    Content0: View
>: TableRowContent {
    public typealias RowContent = VariadicView1<
        Content0
    >

    public var column0: TableColumn<RowValue, Content0>

    public var labels: [String] {
        [
            column0.label
        ]
    }

    public init(
        _ column0: TableColumn<RowValue, Content0>
    ) {
        self.column0 = column0
    }

    public func content(for row: RowValue) -> RowContent {
        VariadicView1(
            column0.content(row)
        )
    }
}

public struct TupleTableRowContent2<
    RowValue,
    Content0: View,
    Content1: View
>: TableRowContent {
    public typealias RowContent = VariadicView2<
        Content0,
        Content1
    >

    public var column0: TableColumn<RowValue, Content0>
    public var column1: TableColumn<RowValue, Content1>

    public var labels: [String] {
        [
            column0.label,
            column1.label,
        ]
    }

    public init(
        _ column0: TableColumn<RowValue, Content0>,
        _ column1: TableColumn<RowValue, Content1>
    ) {
        self.column0 = column0
        self.column1 = column1
    }

    public func content(for row: RowValue) -> RowContent {
        VariadicView2(
            column0.content(row),
            column1.content(row)
        )
    }
}

public struct TupleTableRowContent3<
    RowValue,
    Content0: View,
    Content1: View,
    Content2: View
>: TableRowContent {
    public typealias RowContent = VariadicView3<
        Content0,
        Content1,
        Content2
    >

    public var column0: TableColumn<RowValue, Content0>
    public var column1: TableColumn<RowValue, Content1>
    public var column2: TableColumn<RowValue, Content2>

    public var labels: [String] {
        [
            column0.label,
            column1.label,
            column2.label,
        ]
    }

    public init(
        _ column0: TableColumn<RowValue, Content0>,
        _ column1: TableColumn<RowValue, Content1>,
        _ column2: TableColumn<RowValue, Content2>
    ) {
        self.column0 = column0
        self.column1 = column1
        self.column2 = column2
    }

    public func content(for row: RowValue) -> RowContent {
        VariadicView3(
            column0.content(row),
            column1.content(row),
            column2.content(row)
        )
    }
}

public struct TupleTableRowContent4<
    RowValue,
    Content0: View,
    Content1: View,
    Content2: View,
    Content3: View
>: TableRowContent {
    public typealias RowContent = VariadicView4<
        Content0,
        Content1,
        Content2,
        Content3
    >

    public var column0: TableColumn<RowValue, Content0>
    public var column1: TableColumn<RowValue, Content1>
    public var column2: TableColumn<RowValue, Content2>
    public var column3: TableColumn<RowValue, Content3>

    public var labels: [String] {
        [
            column0.label,
            column1.label,
            column2.label,
            column3.label,
        ]
    }

    public init(
        _ column0: TableColumn<RowValue, Content0>,
        _ column1: TableColumn<RowValue, Content1>,
        _ column2: TableColumn<RowValue, Content2>,
        _ column3: TableColumn<RowValue, Content3>
    ) {
        self.column0 = column0
        self.column1 = column1
        self.column2 = column2
        self.column3 = column3
    }

    public func content(for row: RowValue) -> RowContent {
        VariadicView4(
            column0.content(row),
            column1.content(row),
            column2.content(row),
            column3.content(row)
        )
    }
}

public struct TupleTableRowContent5<
    RowValue,
    Content0: View,
    Content1: View,
    Content2: View,
    Content3: View,
    Content4: View
>: TableRowContent {
    public typealias RowContent = VariadicView5<
        Content0,
        Content1,
        Content2,
        Content3,
        Content4
    >

    public var column0: TableColumn<RowValue, Content0>
    public var column1: TableColumn<RowValue, Content1>
    public var column2: TableColumn<RowValue, Content2>
    public var column3: TableColumn<RowValue, Content3>
    public var column4: TableColumn<RowValue, Content4>

    public var labels: [String] {
        [
            column0.label,
            column1.label,
            column2.label,
            column3.label,
            column4.label,
        ]
    }

    public init(
        _ column0: TableColumn<RowValue, Content0>,
        _ column1: TableColumn<RowValue, Content1>,
        _ column2: TableColumn<RowValue, Content2>,
        _ column3: TableColumn<RowValue, Content3>,
        _ column4: TableColumn<RowValue, Content4>
    ) {
        self.column0 = column0
        self.column1 = column1
        self.column2 = column2
        self.column3 = column3
        self.column4 = column4
    }

    public func content(for row: RowValue) -> RowContent {
        VariadicView5(
            column0.content(row),
            column1.content(row),
            column2.content(row),
            column3.content(row),
            column4.content(row)
        )
    }
}

public struct TupleTableRowContent6<
    RowValue,
    Content0: View,
    Content1: View,
    Content2: View,
    Content3: View,
    Content4: View,
    Content5: View
>: TableRowContent {
    public typealias RowContent = VariadicView6<
        Content0,
        Content1,
        Content2,
        Content3,
        Content4,
        Content5
    >

    public var column0: TableColumn<RowValue, Content0>
    public var column1: TableColumn<RowValue, Content1>
    public var column2: TableColumn<RowValue, Content2>
    public var column3: TableColumn<RowValue, Content3>
    public var column4: TableColumn<RowValue, Content4>
    public var column5: TableColumn<RowValue, Content5>

    public var labels: [String] {
        [
            column0.label,
            column1.label,
            column2.label,
            column3.label,
            column4.label,
            column5.label,
        ]
    }

    public init(
        _ column0: TableColumn<RowValue, Content0>,
        _ column1: TableColumn<RowValue, Content1>,
        _ column2: TableColumn<RowValue, Content2>,
        _ column3: TableColumn<RowValue, Content3>,
        _ column4: TableColumn<RowValue, Content4>,
        _ column5: TableColumn<RowValue, Content5>
    ) {
        self.column0 = column0
        self.column1 = column1
        self.column2 = column2
        self.column3 = column3
        self.column4 = column4
        self.column5 = column5
    }

    public func content(for row: RowValue) -> RowContent {
        VariadicView6(
            column0.content(row),
            column1.content(row),
            column2.content(row),
            column3.content(row),
            column4.content(row),
            column5.content(row)
        )
    }
}

public struct TupleTableRowContent7<
    RowValue,
    Content0: View,
    Content1: View,
    Content2: View,
    Content3: View,
    Content4: View,
    Content5: View,
    Content6: View
>: TableRowContent {
    public typealias RowContent = VariadicView7<
        Content0,
        Content1,
        Content2,
        Content3,
        Content4,
        Content5,
        Content6
    >

    public var column0: TableColumn<RowValue, Content0>
    public var column1: TableColumn<RowValue, Content1>
    public var column2: TableColumn<RowValue, Content2>
    public var column3: TableColumn<RowValue, Content3>
    public var column4: TableColumn<RowValue, Content4>
    public var column5: TableColumn<RowValue, Content5>
    public var column6: TableColumn<RowValue, Content6>

    public var labels: [String] {
        [
            column0.label,
            column1.label,
            column2.label,
            column3.label,
            column4.label,
            column5.label,
            column6.label,
        ]
    }

    public init(
        _ column0: TableColumn<RowValue, Content0>,
        _ column1: TableColumn<RowValue, Content1>,
        _ column2: TableColumn<RowValue, Content2>,
        _ column3: TableColumn<RowValue, Content3>,
        _ column4: TableColumn<RowValue, Content4>,
        _ column5: TableColumn<RowValue, Content5>,
        _ column6: TableColumn<RowValue, Content6>
    ) {
        self.column0 = column0
        self.column1 = column1
        self.column2 = column2
        self.column3 = column3
        self.column4 = column4
        self.column5 = column5
        self.column6 = column6
    }

    public func content(for row: RowValue) -> RowContent {
        VariadicView7(
            column0.content(row),
            column1.content(row),
            column2.content(row),
            column3.content(row),
            column4.content(row),
            column5.content(row),
            column6.content(row)
        )
    }
}

public struct TupleTableRowContent8<
    RowValue,
    Content0: View,
    Content1: View,
    Content2: View,
    Content3: View,
    Content4: View,
    Content5: View,
    Content6: View,
    Content7: View
>: TableRowContent {
    public typealias RowContent = VariadicView8<
        Content0,
        Content1,
        Content2,
        Content3,
        Content4,
        Content5,
        Content6,
        Content7
    >

    public var column0: TableColumn<RowValue, Content0>
    public var column1: TableColumn<RowValue, Content1>
    public var column2: TableColumn<RowValue, Content2>
    public var column3: TableColumn<RowValue, Content3>
    public var column4: TableColumn<RowValue, Content4>
    public var column5: TableColumn<RowValue, Content5>
    public var column6: TableColumn<RowValue, Content6>
    public var column7: TableColumn<RowValue, Content7>

    public var labels: [String] {
        [
            column0.label,
            column1.label,
            column2.label,
            column3.label,
            column4.label,
            column5.label,
            column6.label,
            column7.label,
        ]
    }

    public init(
        _ column0: TableColumn<RowValue, Content0>,
        _ column1: TableColumn<RowValue, Content1>,
        _ column2: TableColumn<RowValue, Content2>,
        _ column3: TableColumn<RowValue, Content3>,
        _ column4: TableColumn<RowValue, Content4>,
        _ column5: TableColumn<RowValue, Content5>,
        _ column6: TableColumn<RowValue, Content6>,
        _ column7: TableColumn<RowValue, Content7>
    ) {
        self.column0 = column0
        self.column1 = column1
        self.column2 = column2
        self.column3 = column3
        self.column4 = column4
        self.column5 = column5
        self.column6 = column6
        self.column7 = column7
    }

    public func content(for row: RowValue) -> RowContent {
        VariadicView8(
            column0.content(row),
            column1.content(row),
            column2.content(row),
            column3.content(row),
            column4.content(row),
            column5.content(row),
            column6.content(row),
            column7.content(row)
        )
    }
}

public struct TupleTableRowContent9<
    RowValue,
    Content0: View,
    Content1: View,
    Content2: View,
    Content3: View,
    Content4: View,
    Content5: View,
    Content6: View,
    Content7: View,
    Content8: View
>: TableRowContent {
    public typealias RowContent = VariadicView9<
        Content0,
        Content1,
        Content2,
        Content3,
        Content4,
        Content5,
        Content6,
        Content7,
        Content8
    >

    public var column0: TableColumn<RowValue, Content0>
    public var column1: TableColumn<RowValue, Content1>
    public var column2: TableColumn<RowValue, Content2>
    public var column3: TableColumn<RowValue, Content3>
    public var column4: TableColumn<RowValue, Content4>
    public var column5: TableColumn<RowValue, Content5>
    public var column6: TableColumn<RowValue, Content6>
    public var column7: TableColumn<RowValue, Content7>
    public var column8: TableColumn<RowValue, Content8>

    public var labels: [String] {
        [
            column0.label,
            column1.label,
            column2.label,
            column3.label,
            column4.label,
            column5.label,
            column6.label,
            column7.label,
            column8.label,
        ]
    }

    public init(
        _ column0: TableColumn<RowValue, Content0>,
        _ column1: TableColumn<RowValue, Content1>,
        _ column2: TableColumn<RowValue, Content2>,
        _ column3: TableColumn<RowValue, Content3>,
        _ column4: TableColumn<RowValue, Content4>,
        _ column5: TableColumn<RowValue, Content5>,
        _ column6: TableColumn<RowValue, Content6>,
        _ column7: TableColumn<RowValue, Content7>,
        _ column8: TableColumn<RowValue, Content8>
    ) {
        self.column0 = column0
        self.column1 = column1
        self.column2 = column2
        self.column3 = column3
        self.column4 = column4
        self.column5 = column5
        self.column6 = column6
        self.column7 = column7
        self.column8 = column8
    }

    public func content(for row: RowValue) -> RowContent {
        VariadicView9(
            column0.content(row),
            column1.content(row),
            column2.content(row),
            column3.content(row),
            column4.content(row),
            column5.content(row),
            column6.content(row),
            column7.content(row),
            column8.content(row)
        )
    }
}

public struct TupleTableRowContent10<
    RowValue,
    Content0: View,
    Content1: View,
    Content2: View,
    Content3: View,
    Content4: View,
    Content5: View,
    Content6: View,
    Content7: View,
    Content8: View,
    Content9: View
>: TableRowContent {
    public typealias RowContent = VariadicView10<
        Content0,
        Content1,
        Content2,
        Content3,
        Content4,
        Content5,
        Content6,
        Content7,
        Content8,
        Content9
    >

    public var column0: TableColumn<RowValue, Content0>
    public var column1: TableColumn<RowValue, Content1>
    public var column2: TableColumn<RowValue, Content2>
    public var column3: TableColumn<RowValue, Content3>
    public var column4: TableColumn<RowValue, Content4>
    public var column5: TableColumn<RowValue, Content5>
    public var column6: TableColumn<RowValue, Content6>
    public var column7: TableColumn<RowValue, Content7>
    public var column8: TableColumn<RowValue, Content8>
    public var column9: TableColumn<RowValue, Content9>

    public var labels: [String] {
        [
            column0.label,
            column1.label,
            column2.label,
            column3.label,
            column4.label,
            column5.label,
            column6.label,
            column7.label,
            column8.label,
            column9.label,
        ]
    }

    public init(
        _ column0: TableColumn<RowValue, Content0>,
        _ column1: TableColumn<RowValue, Content1>,
        _ column2: TableColumn<RowValue, Content2>,
        _ column3: TableColumn<RowValue, Content3>,
        _ column4: TableColumn<RowValue, Content4>,
        _ column5: TableColumn<RowValue, Content5>,
        _ column6: TableColumn<RowValue, Content6>,
        _ column7: TableColumn<RowValue, Content7>,
        _ column8: TableColumn<RowValue, Content8>,
        _ column9: TableColumn<RowValue, Content9>
    ) {
        self.column0 = column0
        self.column1 = column1
        self.column2 = column2
        self.column3 = column3
        self.column4 = column4
        self.column5 = column5
        self.column6 = column6
        self.column7 = column7
        self.column8 = column8
        self.column9 = column9
    }

    public func content(for row: RowValue) -> RowContent {
        VariadicView10(
            column0.content(row),
            column1.content(row),
            column2.content(row),
            column3.content(row),
            column4.content(row),
            column5.content(row),
            column6.content(row),
            column7.content(row),
            column8.content(row),
            column9.content(row)
        )
    }
}
