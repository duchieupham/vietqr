class MonthCalculator {
  int calculateMonths(DateTime startDate, DateTime endDate) {
    int months = 0;
    int startYear = startDate.year;
    int startMonth = startDate.month;
    int endYear = endDate.year;
    int endMonth = endDate.month;

    months += (endYear - startYear) * 12;
    months += endMonth - startMonth;

    return months;
  }
}
