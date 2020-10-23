import SwiftUI

/// Grid view, with an API similar to list types.
public struct Grid<Data, Content>: View
where Data: RandomAccessCollection, Content: View {
	
	private let data: Data
	private let columns: Int
	private let columnsInLandscape: Int
	private let verticalSpacing: CGFloat
	private let horizontalSpacing: CGFloat
	private let isScrollable: Bool
	private let showScrollIndicators: Bool
	private let content: (Data.Element) -> Content
	
	private var numberOfColumns: Int {
		UIDevice.current.orientation.isLandscape ? columnsInLandscape : columns
	}
	
	private var numberOfRows: Int {
		data.count/numberOfColumns + 1
	}
	
	public init(
		_ data: Data,
		columns: Int,
		columnsInLandscape: Int? = nil,
		verticalSpacing: CGFloat = 16,
		horizontalSpacing: CGFloat = 16,
		isScrollable: Bool = true,
		showScrollIndicators: Bool = false,
		content: @escaping (Data.Element) -> Content
	) {
		self.data = data
		self.columns = max(1, columns)
		self.columnsInLandscape = columnsInLandscape ?? max(1, columns)
		self.verticalSpacing = verticalSpacing
		self.horizontalSpacing = horizontalSpacing
		self.isScrollable = isScrollable
		self.showScrollIndicators = showScrollIndicators
		self.content = content
	}
	
	public var body: some View {
		if isScrollable {
			ScrollView(showsIndicators: showScrollIndicators, content: grid)
		} else {
			grid()
		}
	}
}

private extension Grid {
	func grid() -> some View {
		VStack(spacing: verticalSpacing) {
			ForEach(0..<numberOfRows, content: row(atIndex:))
		}
	}
	
	func row(atIndex rowIndex: Int) -> some View {
		let isLastRow = rowIndex == numberOfRows - 1
		
		let numberOfItemsInRow = isLastRow ? data.count % numberOfColumns : numberOfColumns
		
		return HStack(spacing: horizontalSpacing) {
			ForEach(0..<numberOfColumns) { columnIndex in
				Group {
					if columnIndex < numberOfItemsInRow {
						contentView(at: rowIndex * numberOfColumns + columnIndex)
							.frame(maxWidth: .infinity)
					} else {
						Spacer()
					}
				}.frame(maxWidth: .infinity)
			}
		}
	}
	
	func contentView(at indexOffset: Int) -> some View {
		let index = data.index(data.startIndex, offsetBy: indexOffset)
		return content(data[index])
	}
}

struct Grid_Previews: PreviewProvider {
	static var previews: some View {
		Grid((1..<11), columns: 3) {
			Text("\($0)")
				.frame(maxWidth: .infinity)
				.background(Color.blue)
		}
	}
}
