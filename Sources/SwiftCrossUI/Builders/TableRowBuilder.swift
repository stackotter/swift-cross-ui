/// A result builder for constructing a collection of table columns.
@resultBuilder
public struct TableRowBuilder<RowValue> {
    public static func buildBlock() -> EmptyTableRowContent<RowValue> {
        EmptyTableRowContent<RowValue>()
    }

    public static func buildBlock<
        Content0: View
    >(
        _ column0: TableColumn<RowValue, Content0>
    ) -> TupleTableRowContent1<
        RowValue,
        Content0
    > {
        TupleTableRowContent1(
            column0
        )
    }
    public static func buildBlock<
        Content0: View,
        Content1: View
    >(
        _ column0: TableColumn<RowValue, Content0>,
        _ column1: TableColumn<RowValue, Content1>
    ) -> TupleTableRowContent2<
        RowValue,
        Content0,
        Content1
    > {
        TupleTableRowContent2(
            column0,
            column1
        )
    }
    public static func buildBlock<
        Content0: View,
        Content1: View,
        Content2: View
    >(
        _ column0: TableColumn<RowValue, Content0>,
        _ column1: TableColumn<RowValue, Content1>,
        _ column2: TableColumn<RowValue, Content2>
    ) -> TupleTableRowContent3<
        RowValue,
        Content0,
        Content1,
        Content2
    > {
        TupleTableRowContent3(
            column0,
            column1,
            column2
        )
    }
    public static func buildBlock<
        Content0: View,
        Content1: View,
        Content2: View,
        Content3: View
    >(
        _ column0: TableColumn<RowValue, Content0>,
        _ column1: TableColumn<RowValue, Content1>,
        _ column2: TableColumn<RowValue, Content2>,
        _ column3: TableColumn<RowValue, Content3>
    ) -> TupleTableRowContent4<
        RowValue,
        Content0,
        Content1,
        Content2,
        Content3
    > {
        TupleTableRowContent4(
            column0,
            column1,
            column2,
            column3
        )
    }
    public static func buildBlock<
        Content0: View,
        Content1: View,
        Content2: View,
        Content3: View,
        Content4: View
    >(
        _ column0: TableColumn<RowValue, Content0>,
        _ column1: TableColumn<RowValue, Content1>,
        _ column2: TableColumn<RowValue, Content2>,
        _ column3: TableColumn<RowValue, Content3>,
        _ column4: TableColumn<RowValue, Content4>
    ) -> TupleTableRowContent5<
        RowValue,
        Content0,
        Content1,
        Content2,
        Content3,
        Content4
    > {
        TupleTableRowContent5(
            column0,
            column1,
            column2,
            column3,
            column4
        )
    }
    public static func buildBlock<
        Content0: View,
        Content1: View,
        Content2: View,
        Content3: View,
        Content4: View,
        Content5: View
    >(
        _ column0: TableColumn<RowValue, Content0>,
        _ column1: TableColumn<RowValue, Content1>,
        _ column2: TableColumn<RowValue, Content2>,
        _ column3: TableColumn<RowValue, Content3>,
        _ column4: TableColumn<RowValue, Content4>,
        _ column5: TableColumn<RowValue, Content5>
    ) -> TupleTableRowContent6<
        RowValue,
        Content0,
        Content1,
        Content2,
        Content3,
        Content4,
        Content5
    > {
        TupleTableRowContent6(
            column0,
            column1,
            column2,
            column3,
            column4,
            column5
        )
    }
    public static func buildBlock<
        Content0: View,
        Content1: View,
        Content2: View,
        Content3: View,
        Content4: View,
        Content5: View,
        Content6: View
    >(
        _ column0: TableColumn<RowValue, Content0>,
        _ column1: TableColumn<RowValue, Content1>,
        _ column2: TableColumn<RowValue, Content2>,
        _ column3: TableColumn<RowValue, Content3>,
        _ column4: TableColumn<RowValue, Content4>,
        _ column5: TableColumn<RowValue, Content5>,
        _ column6: TableColumn<RowValue, Content6>
    ) -> TupleTableRowContent7<
        RowValue,
        Content0,
        Content1,
        Content2,
        Content3,
        Content4,
        Content5,
        Content6
    > {
        TupleTableRowContent7(
            column0,
            column1,
            column2,
            column3,
            column4,
            column5,
            column6
        )
    }
    public static func buildBlock<
        Content0: View,
        Content1: View,
        Content2: View,
        Content3: View,
        Content4: View,
        Content5: View,
        Content6: View,
        Content7: View
    >(
        _ column0: TableColumn<RowValue, Content0>,
        _ column1: TableColumn<RowValue, Content1>,
        _ column2: TableColumn<RowValue, Content2>,
        _ column3: TableColumn<RowValue, Content3>,
        _ column4: TableColumn<RowValue, Content4>,
        _ column5: TableColumn<RowValue, Content5>,
        _ column6: TableColumn<RowValue, Content6>,
        _ column7: TableColumn<RowValue, Content7>
    ) -> TupleTableRowContent8<
        RowValue,
        Content0,
        Content1,
        Content2,
        Content3,
        Content4,
        Content5,
        Content6,
        Content7
    > {
        TupleTableRowContent8(
            column0,
            column1,
            column2,
            column3,
            column4,
            column5,
            column6,
            column7
        )
    }
    public static func buildBlock<
        Content0: View,
        Content1: View,
        Content2: View,
        Content3: View,
        Content4: View,
        Content5: View,
        Content6: View,
        Content7: View,
        Content8: View
    >(
        _ column0: TableColumn<RowValue, Content0>,
        _ column1: TableColumn<RowValue, Content1>,
        _ column2: TableColumn<RowValue, Content2>,
        _ column3: TableColumn<RowValue, Content3>,
        _ column4: TableColumn<RowValue, Content4>,
        _ column5: TableColumn<RowValue, Content5>,
        _ column6: TableColumn<RowValue, Content6>,
        _ column7: TableColumn<RowValue, Content7>,
        _ column8: TableColumn<RowValue, Content8>
    ) -> TupleTableRowContent9<
        RowValue,
        Content0,
        Content1,
        Content2,
        Content3,
        Content4,
        Content5,
        Content6,
        Content7,
        Content8
    > {
        TupleTableRowContent9(
            column0,
            column1,
            column2,
            column3,
            column4,
            column5,
            column6,
            column7,
            column8
        )
    }
    public static func buildBlock<
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
    >(
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
    ) -> TupleTableRowContent10<
        RowValue,
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
    > {
        TupleTableRowContent10(
            column0,
            column1,
            column2,
            column3,
            column4,
            column5,
            column6,
            column7,
            column8,
            column9
        )
    }
}
