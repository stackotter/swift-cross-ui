import SwiftCrossUI

struct Column: View {
    var body: some View {
        HStack {
            Color.orange.frame(width: 5)
            Text("Lorem ipsum dolor sit amet.")
        }
    }
}

struct DoubleColumn: View {
    var body: some View {
        HStack {
            Column()
            Column()
        }
    }
}

struct Row: View {
    var body: some View {
        HStack {
            HStack {
                DoubleColumn()
                DoubleColumn()
                DoubleColumn()
                DoubleColumn()
            }
            HStack {
                DoubleColumn()
                DoubleColumn()
                DoubleColumn()
                DoubleColumn()
            }
        }
    }
}

struct DoubleRow: View {
    var body: some View {
        VStack {
            Row()
            Row()
        }
    }
}

struct GridView: TestCaseView {
    var body: some View {
        VStack {
            VStack {
                DoubleRow()
                DoubleRow()
                DoubleRow()
                DoubleRow()
            }
            VStack {
                DoubleRow()
                DoubleRow()
                DoubleRow()
                DoubleRow()
            }
        }
    }
}
