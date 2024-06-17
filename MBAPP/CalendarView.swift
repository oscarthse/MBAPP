import SwiftUI
import EventKit

struct CalendarView: View {
    @Binding var selectedDate: Date
    @Binding var events: [Event]

    private let calendar = Calendar.current
    private let daysInWeek = 7
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        VStack {
            HStack {
                Text("\(monthYearString(from: selectedDate))")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            HStack {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                    Text(day)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)

            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(daysInMonth(for: selectedDate), id: \.self) { date in
                    Text("\(dayString(from: date))")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .background(isSameDay(date1: date, date2: selectedDate) ? Color("customPurple") : Color.clear)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                        .onTapGesture {
                            selectedDate = date
                        }
                }
            }
            .padding()

            List {
                ForEach(eventsForSelectedDate, id: \.id) { event in
                    Text(event.description)
                }
            }
        }
    }

    private var eventsForSelectedDate: [Event] {
        events.filter { isSameDay(date1: $0.time, date2: selectedDate) }
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
        calendar.isDate(date1, inSameDayAs: date2)
    }
}
