import SwiftUI
import EventKit

struct CalendarView: View {
    @Binding var selectedDate: Date
    @Binding var events: [Event]

    private let calendar = Calendar.current
    private let daysInWeek = 4 // Adjust for larger cells
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4) // Adjust for larger cells

    var body: some View {
        ZStack {
            GradientBackground()
            VStack(spacing: 20) {
                // Month and Year Header
                HStack {
                    Button(action: {
                        selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                    }) {
                        Image(systemName: "chevron.left")
                            .padding()
                            .background(Color("primaryPurple"))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text("\(monthYearString(from: selectedDate))")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                    }) {
                        Image(systemName: "chevron.right")
                            .padding()
                            .background(Color("primaryPurple"))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)

                // Days of the Week Header
                HStack {
                    ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                        Text(day)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)

                // Monthly Calendar Grid
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(daysInMonth(for: selectedDate), id: \.self) { date in
                        Text("\(dayString(from: date))")
                            .font(.headline)
                            .foregroundColor(isSameDay(date1: date, date2: selectedDate) ? .white : .primary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                            .background(isSameDay(date1: date, date2: selectedDate) ? Color.pink : (hasEvent(on: date) ? Color.purple : Color.clear))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .onTapGesture {
                                selectedDate = date
                            }
                            .aspectRatio(1, contentMode: .fit) // Ensure cells are square
                    }
                }
                .padding()

                // Events for Selected Date
                if eventsForSelectedDate.isEmpty {
                    Text("No events for selected date")
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(eventsForSelectedDate, id: \.id) { event in
                            Text(event.description)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .background(Color.clear)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("background"))
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            )
            .padding()
        }
    }

    private var eventsForSelectedDate: [Event] {
        events.filter { isSameDay(date1: $0.time, date2: selectedDate) }
    }

    private func hasEvent(on date: Date) -> Bool {
        events.contains { isSameDay(date1: $0.time, date2: date) }
    }

    private func daysInMonth(for date: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start)
        else { return [] }

        return (0..<daysInWeek * 6).compactMap {
            calendar.date(byAdding: .day, value: $0, to: monthFirstWeek.start)
        }
    }

    private func dayString(from date: Date) -> String {
        let day = calendar.component(.day, from: date)
        return "\(day)"
    }

    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    private func isSameDay(date1: Date, date2: Date) -> Bool {
        calendar.isDate(date1, equalTo: date2, toGranularity: .day)
    }
}
