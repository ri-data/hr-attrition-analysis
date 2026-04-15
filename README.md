# HR Attrition Analysis
## Why I Built This
Every company loses employees. But most HR teams don't know why until 
it's too late. This project digs into workforce data to find the real 
drivers of attrition — not guesses, but patterns backed by data.
As someone who worked in operations and quality at Uber, I've seen 
firsthand how losing good people affects team performance and morale.
This project is my attempt to give HR teams the data they need to act 
before employees walk out the door.
## Dataset
- 628 employees across multiple departments
- Includes salary, engagement score, satisfaction score, training hours,
  absenteeism, distance from work, promotion history
- Source: Synthetic HR dataset
## Business Questions Answered
1. What is the overall attrition rate?
2. Which departments have the highest attrition?
3. Does salary affect attrition?
4. Does training reduce attrition?
5. Does distance from work increase attrition?
6. What is the relationship between engagement score and attrition?
7. Does promotion history affect whether employees stay?
## What I Did

**Phase 1 — Data Exploration**
Explored employee distribution by department, age group, gender,
and salary to understand the workforce baseline.

**Phase 2 — Data Cleaning**
Built a cleaned analysis table with standardised positions, age groups,
salary buckets, training hour buckets, distance buckets, and calculated
job satisfaction rate and employee benefit rate.

**Phase 3 — Attrition Deep Dive**
Analysed attrition by every available dimension — department, salary,
engagement score, satisfaction score, training hours, absenteeism,
distance, promotion, and years of service.

**Phase 4 — Multi-factor Analysis**
Combined department, engagement score, and satisfaction score to 
identify which departments are at highest risk and why.

## Key Findings
- Overall attrition rate is 48% — alarmingly high
- Low employee engagement score is the strongest predictor of attrition
- Employees receiving less than 10 training hours have the highest 
  attrition rate — training investment directly reduces attrition
- Employees living 40+ km from work show significantly higher attrition
- Low salary band (under 10L) has the highest attrition rate
- Gender has no significant effect on attrition
  
## Recommendations
1. Prioritise engagement programmes in high-attrition departments
2. Mandate minimum 20 training hours per employee per year
3. Introduce remote work or transport allowance for employees 
   living 40+ km away
4. Review salary bands — low earners are leaving at the highest rate
5. Tie promotion reviews to tenure milestones to reward loyalty

## Tools
MySQL, SQL Workbench
