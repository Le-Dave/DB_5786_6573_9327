# 📘 מערכת ניהול מסעדה

**מחלקה:** ניהול תפריט

---

## 👨‍💻 מחברים

- **דוד נחום** - ת.ז: 341106573
- **נריה הורנצ'יק** - ת.ז: 208729327

## 🏢 תחום הפרויקט

- **מערכת:** מערכת ניהול מסעדה
- **יחידה:** מחלקת ניהול תפריט

---

## 📌 תוכן עניינים

### שלב א': עיצוב מסד הנתונים והבסיס

1.  [סקירה כללית](#-סקירה-כללית)
2.  [ממשק המערכת](#-ממשק-המערכת)
3.  [דיאגרמות ERD ו-DSD](#-דיאגרמות-erd-ו-dsd)
4.  [תיאור מבנה הנתונים](#-תיאור-מבנה-הנתונים)
5.  [החלטות עיצוב](#-החלטות-עיצוב)
6.  [שיטות הכנסת נתונים](#-שיטות-הכנסת-נתונים)
7.  [גיבוי ושחזור](#-גיבוי-ושחזור)

### שלב ב': שאילתות מתקדמות ושלמות נתונים

8. [שאילתות SELECT השוואתיות](#-שאילתות-select-השוואתיות)
9. [שאילתות SELECT נוספות](#-שאילתות-select-נוספות)
10. [שאילתות DELETE](#-שאילתות-delete)
11. [שאילתות UPDATE](#-שאילתות-update)
12. [אילוצי מסד הנתונים ושינויים](#-אילוצי-מסד-הנתונים-ושינויים)
13. [בקרת טרנזקציות](#-בקרת-טרנזקציות-rollback--commit)
14. [גיבוי ושחזור - שלב ב'](#-גיבוי-ושחזור---שלב-ב)

### שלב ג': אינטגרציה ומבטים

15. [סקירת האינטגרציה](#-סקירת-האינטגרציה)
16. [אלגוריתם הינדוס לאחור](#-אלגוריתם-הינדוס-לאחור)
17. [דיאגרמות שלב ג'](#-דיאגרמות-שלב-ג)
18. [החלטות בשלב האינטגרציה](#-החלטות-בשלב-האינטגרציה)
19. [תהליך האינטגרציה והפקודות](#-תהליך-האינטגרציה-והפקודות)
20. [מבטים](#-מבטים)
21. [גיבוי - שלב ג'](#-גיבוי---שלב-ג)

### שלב ד': תכנות (PL/pgSQL)

22. [סקירת התכנות](#-סקירת-התכנות)
23. [שינוי טבלאות - AlterTable](#-שינוי-טבלאות---altertable)
24. [פונקציות](#-פונקציות)
25. [פרוצדורות](#-פרוצדורות)
26. [טריגרים](#-טריגרים)
27. [תוכניות ראשיות](#-תוכניות-ראשיות)
28. [גיבוי - שלב ד'](#-גיבוי---שלב-ד)

### שלב ה': ממשק גרפי (GUI)

29. [סקירת הממשק הגרפי](#-סקירת-הממשק-הגרפי)
30. [כלים ודרך העבודה](#-כלים-ודרך-העבודה)
31. [הוראות הפעלה](#-הוראות-הפעלה)
32. [צילומי מסך של האפליקציה](#-צילומי-מסך-של-האפליקציה)

---

# 🏁 שלב א': עיצוב מסד הנתונים והבסיס

## 📃 סקירה כללית

**מחלקת ניהול התפריט** היא עמוד השדרה של תהליך העבודה התפעולי של המסעדה. המערכת מיועדת לנהל את מחזור החיים המלא של מנה, החל מהקטגוריה הרחבה שלה ועד לפרטים הטכניים הגרגורים של המתכון והמרכיבים.

**פונקציות מרכזיות:**

- ארגון פריטי התפריט לקטגוריות לוגיות.
- הגדרת מתכונים טכניים מדויקים לצוות המטבח.
- קישור מתכונים למלאי המרכיבים למעקב עתידי.
- שמירת רשומת ביקורת מלאה של כל שינוי (מחיר, זמינות) שנעשה בתפריט.

---

## 🖥 ממשק המערכת

_נוצר באמצעות Google AI Studio_

להלן מסכי הרעיון המייצגים את עיצוב "מלמעלה למטה" של האפליקציה:

**לוח בקרה**

![מסך אפליקציה 1](./Stage%20A/Screenshots/App1.png)

**ניהול תפריט**

![מסך אפליקציה 2](./Stage%20A/Screenshots/App2.png)

**תצוגת תפריט חי**

![מסך אפליקציה 3](./Stage%20A/Screenshots/App3.png)

**ניתוח תפריט**

![מסך אפליקציה 4](./Stage%20A/Screenshots/App4.png)

### 🔗 אב-טיפוס אינטראקטיבי

ניתן לגשת לעיצוב האפליקציה האינטראקטיבי שנוצר ב-Google AI Studio דרך הקישור הבא:
[**צפייה באב-טיפוס האינטראקטיבי לניהול תפריט**](https://aistudio.google.com/apps/fea1348c-0085-43f5-a3fc-40957a48e11b?showPreview=true&showAssistant=true)

---

## 📂 דיאגרמות ERD ו-DSD

### ERD (דיאגרמת קשרי ישויות)

ה-ERD מציג את הישויות הלוגיות הרעיוניות ואת הקשרים ביניהן.

![דיאגרמת ERD](./Stage%20A/ERD%20Menu%20Managment%20Department%205786.png)

### DSD (דיאגרמת סכמת נתונים)

ה-DSD (סכמה רלציונית) מציג את מבני הטבלאות הפיזיות, כולל מפתחות ראשיים וזרים.

![דיאגרמת DSD](./Stage%20A/DSD%20Menu%20Managment%20Department%205786-Relational%20Schema.png)

---

## 🗃 תיאור מבנה הנתונים

מסד הנתונים מורכב מ-**6 טבלאות** שתוכננו לטפל בכל דבר החל מארגון תפריט ברמה גבוהה ועד למדידות מרכיבים גרגוריות.

### 1. MENU_CATEGORY (קטגוריית תפריט)

טבלה זו משמשת כמבנה הארגוני הראשי של התפריט.

- **category_id (מפתח ראשי):** מספר שלם ייחודי עם קידום אוטומטי (Serial) המזהה כל קטגוריה.
- **category_name (שם קטגוריה):** שם תיאורי ייחודי (למשל, 'מנות עיקריות', 'משקאות').
  - _אילוץ:_ חייב להיות ייחודי ולהכיל לפחות 2 תווים.
- **description (תיאור - אופציונלי):** טקסט קצר המתאר את תכולת הקטגוריה.

### 2. INGREDIENT (מרכיב)

מייצג את חומרי הגלם הזמינים במחסן המסעדה.

- **ingredient_id (מפתח ראשי):** מזהה ייחודי לכל מרכיב גולמי.
- **ingredient_name (שם מרכיב):** שם המרכיב (למשל, 'מלח ים', 'קמח אורגני').
  - _אילוץ:_ חייב להיות ייחודי למניעת כפילויות במלאי.
- **unit (יחידת מידה):** יחידת המידה הסטנדרטית עבור מרכיב זה (למשל, 'ק"ג', 'גרם', 'ליטר', 'יחידות').

### 3. MENU_ITEM (פריט תפריט)

הישות המרכזית של המערכת, המייצגת את המנות הנמכרות ללקוחות.

- **menu_item_id (מפתח ראשי):** מזהה ייחודי לכל מנה.
- **item_name (שם פריט):** השם המסחרי של המנה.
  - _אילוץ:_ חייב להיות ייחודי.
- **price (מחיר):** מחיר המכירה של הפריט.
  - _אילוץ:_ חייב להיות גדול מ-0.
- **description (תיאור - אופציונלי):** תיאור מסחרי להצגה בתפריט.
- **is_available (זמין):** דגל בוליאני המציין אם המנה ניתנת להזמנה כרגע.
- **added_date (תאריך הוספה):** התאריך שבו הפריט הוצג לראשונה בתפריט.
  - _אילוץ:_ לא יכול להיות תאריך עתידי (<= תאריך נוכחי).
- **calories (קלוריות - אופציונלי):** ערך קלורי כולל למידע תזונתי.
  - _אילוץ:_ חייב להיות גדול מ-0 או שווה לו.
- **category_id (מפתח זר):** מקשר את הפריט לקטגוריה האב שלו.

### 4. RECIPE (מתכון)

הרחבה של פריט התפריט המספקת נתוני בישול טכניים.

- **recipe_id (מפתח ראשי):** מזהה ייחודי למתכון.
- **instructions (הוראות):** הוראות הכנה מפורטות שלב-אחר-שלב.
  - _אילוץ:_ חייב להכיל לפחות 10 תווים להבטחת פירוט מספק.
- **menu_item_id (מפתח זר/ייחודי):** מקשר את המתכון לפריט תפריט אחד בדיוק, ושומר על **קשר 1:1**.

### 5. RECIPE_INGREDIENT (מרכיב במתכון)

טבלה אסוציאטיבית המגדירה את ההרכב הספציפי של כל מתכון. טבלה זו מאפשרת את קשר רבים-לרבים בין מתכונים למרכיבים.

- **recipe_ingredient_id (מפתח ראשי):** מזהה ייחודי לכל שורה בהרכב.
- **quantity (כמות):** הכמות המדויקת של המרכיב הנדרשת למתכון.
  - _אילוץ:_ חייבת להיות גדולה מ-0.
- **recipe_id (מפתח זר):** הפניה למתכון המורכב.
- **ingredient_id (מפתח זר):** הפניה למרכיב הגולמי המשמש.

### 6. MENU_CHANGE_LOG (יומן שינויי תפריט)

טבלת ביקורת למעקב אחר כל השינויים המנהלתיים שנעשו בתפריט לאורך זמן.

- **change_id (מפתח ראשי):** מזהה ייחודי לרשומת היומן.
- **change_description (תיאור שינוי - אופציונלי):** הסבר על מה שהשתנה (למשל, 'עדכון מחיר', 'תיקון שם').
- **change_date (תאריך שינוי):** חותמת זמן של מועד ביצוע השינוי.
- **menu_item_id (מפתח זר):** הפניה לפריט התפריט הספציפי שהשתנה.

---

## 🧠 החלטות עיצוב

- **נרמול 3NF:** הסכמה מנורמלת במלואה לצורה הנורמלית השלישית למניעת כפילויות נתונים והבטחת שלמות.
- **קשרים מזהים:** השתמשנו בקשרים מזהים עבור `Recipe` ו-`Log` מכיוון שאינם יכולים להתקיים ללא `Menu_Item` אב.
- **שלמות נתונים:** יישמנו אילוצי `CHECK` על מחיר (>0), קלוריות (>=0) וכמות (>0) למניעת שגיאות הזנת נתונים לוגיות.
- **מעקב זמני:** כללנו `added_date` ו-`change_date` לעמידה בדרישה לתכונות תאריך משמעותיות.

---

## 📥 שיטות הכנסת נתונים

מסד הנתונים אוכלס ביותר מ-**41,000 רשומות** באמצעות שלוש שיטות שונות:

### ✅ שיטה א': Mockaroo (סקריפטי SQL)

שימש ליצירת 500 רשומות ריאליסטיות לקטגוריות, פריטי תפריט ומתכונים.

![צילום מסך Mockaroo](./Stage%20A/Screenshots/Mockaroo.png)

![צילום מסך Mockaroo](./Stage%20A/Screenshots/Mockaroo_pgAdmin.png)

### ✅ שיטה ב': ייבוא נתונים (CSV)

טבלת `Ingredient` אוכלסה על ידי ייבוא קובץ `ingredients.csv` חיצוני באמצעות כלי הייבוא של pgAdmin.

![ייבוא pgAdmin](./Stage%20A/Screenshots/Ingredient_csv.png)

![ייבוא pgAdmin](./Stage%20A/Screenshots/Ingredient_csv_IMPORT.png)

### ✅ שיטה ג': סקריפט Python

פותח סקריפט Python מותאם אישית ליצירת נתונים בנפח גבוה (**20,000 שורות כל אחד**) עבור טבלאות האסוציאציה ויומן הביקורת.

![הרצת Python](./Stage%20A/Screenshots/PythonScript.png)

![הרצת Python](./Stage%20A/Screenshots/PythonScript_pgAdmin.png)

---

## 💾 גיבוי ושחזור

להבטחת בטיחות הפרויקט ונייידותו, בוצע גיבוי מלא של מסד הנתונים ונבדק.

1.  **תהליך הגיבוי:** נוצר ארכיון `.tar` דחוס.

![הצלחת גיבוי](./Stage%20A/Screenshots/Backup.png)

2.  **בדיקת שחזור:** הגיבוי שוחזר בהצלחה למסד נתונים חדש בשם `DB_Test_Restore`.

![אימות שחזור](./Stage%20A/Screenshots/Restore.png)

---

# 🚀 שלב ב': שאילתות מתקדמות ושלמות נתונים

## 🔍 שאילתות SELECT השוואתיות

_ביצוע שאילתות בשתי גרסאות לניתוח ביצועים._

### שאילתה 1: פריטים שנוספו ב-2024 עם שמות קטגוריות

**מה היא עושה:** שאילתה זו מזהה את כל המנות שהוצגו במהלך שנת 2024. היא מחלצת את השנה מ-`added_date` ומבצעת join להצגת שם הקטגוריה במקום מזהה מספרי.

**גרסה א' (JOIN):**

```sql
SELECT mi.item_name, mi.price, mc.category_name, EXTRACT(YEAR FROM mi.added_date) AS year_added
FROM MENU_ITEM mi
JOIN MENU_CATEGORY mc ON mi.category_id = mc.category_id
WHERE EXTRACT(YEAR FROM mi.added_date) = 2024;
```

![תוצאת שאילתה 1](./Stage%20B/Screenshots/Select_1_VersA.png)

**גרסה ב' (תת-שאילתה סקלרית):**

```sql
SELECT item_name, price,
       (SELECT category_name FROM MENU_CATEGORY mc WHERE mc.category_id = mi.category_id) AS category_name,
       EXTRACT(YEAR FROM added_date) AS year_added
FROM MENU_ITEM mi
WHERE EXTRACT(YEAR FROM added_date) = 2024;
```

![תוצאת שאילתה 1](./Stage%20B/Screenshots/Select_1_VersB.png)

**השוואת יעילות:** **גרסה א' (JOIN)** יעילה יותר. ב-PostgreSQL, JOIN מאפשר למייעל להשתמש באלגוריתמי "Hash Join" לעיבוד הטבלאות במעבר אחד. גרסה ב' משתמשת ב"תת-שאילתה סקלרית", המאלצת את המנוע לבצע חיפוש נפרד לכל שורה בטבלת פריטי התפריט, מה שגורם לביצועים ירודים ככל שנפח הנתונים גדל.

### שאילתה 2: מרכיבים המשמשים ביותר מ-20 מתכונים

**מה היא עושה:** שאילתה זו סורקת את טבלת RECIPE_INGREDIENT בת 20,000 השורות כדי למצוא מרכיבים "בשימוש גבוה" שגמישים מספיק לשימוש ביותר מ-20 מנות שונות.

**גרסה א' (GROUP BY / HAVING):**

```sql
SELECT i.ingredient_name, i.unit, COUNT(ri.recipe_id) AS total_recipes
FROM INGREDIENT i
JOIN RECIPE_INGREDIENT ri ON i.ingredient_id = ri.ingredient_id
GROUP BY i.ingredient_name, i.unit
HAVING COUNT(ri.recipe_id) > 20;
```

![תוצאת שאילתה 2](./Stage%20B/Screenshots/Select_2_VersA.png)

**גרסה ב' (תת-שאילתה סקלרית):**

```sql
SELECT i.ingredient_name, i.unit,
       (SELECT COUNT(*) FROM RECIPE_INGREDIENT ri WHERE ri.ingredient_id = i.ingredient_id) AS total_recipes
FROM INGREDIENT i
WHERE (SELECT COUNT(*) FROM RECIPE_INGREDIENT ri WHERE ri.ingredient_id = i.ingredient_id) > 20;
```

![תוצאת שאילתה 2](./Stage%20B/Screenshots/Select_2_VersB.png)

**השוואת יעילות:** **גרסה א' (GROUP BY / HAVING)** עדיפה כי היא משתמשת ב"Hash Aggregation", סורקת את הטבלה האסוציאטיבית פעם אחת בלבד לספירת כל המופעים. גרסה ב' מבצעת חישוב הספירה פעמיים לכל שורה (פעם עבור ה-SELECT ופעם עבור ה-WHERE), מה שמוביל לכפילות עצומה.

### שאילתה 3: פריטים במחיר מעל הממוצע בקטגוריה שלהם

**מה היא עושה:** כלי לניתוח עסקי למציאת פריטים יקרים יחסית לעמיתיהם. היא מחשבת את המחיר הממוצע של כל קטגוריה ומסננת מנות העולות על ערך זה.

**גרסה א' (טבלה נגזרת + JOIN):**

```sql
SELECT mi.item_name, mi.price, ROUND(sub.avg_cat_price, 2) AS category_average
FROM MENU_ITEM mi
JOIN (SELECT category_id, AVG(price) AS avg_cat_price FROM MENU_ITEM GROUP BY category_id) sub
  ON mi.category_id = sub.category_id
WHERE mi.price > sub.avg_cat_price;
```

![תוצאת שאילתה 3](./Stage%20B/Screenshots/Select_3_VersA.png)

**גרסה ב' (תת-שאילתה סקלרית):**

```sql
SELECT mi.item_name, mi.price,
       (SELECT ROUND(AVG(price), 2) FROM MENU_ITEM mi2 WHERE mi2.category_id = mi.category_id) AS category_average
FROM MENU_ITEM mi
WHERE mi.price > (SELECT AVG(price) FROM MENU_ITEM mi3 WHERE mi3.category_id = mi.category_id);
```

![תוצאת שאילתה 3](./Stage%20B/Screenshots/Select_3_VersB.png)

**השוואת יעילות:** **גרסה א' (טבלה נגזרת + JOIN)** יעילה מאוד כי היא מחשבת את הממוצע עבור כל אחת מ-500 הקטגוריות פעם אחת בדיוק. גרסה ב' בעלת מורכבות O(N²), כי היא מפעילה סריקה מלאה וחישוב ממוצע לכל מנה בנפרד, שהוא ביצועי ביותר.

### שאילתה 4: פריטים סטטיים ב-2026 (ללא שינויים)

**מה היא עושה:** שאילתה זו מזהה מנות שהיו יציבות ולא עברו שינויי מחיר או זמינות במהלך שנת 2026 על ידי בדיקת היעדר רשומות יומן.

**גרסה א' (NOT EXISTS):**

```sql
SELECT mi.item_name, mi.added_date, mi.price
FROM MENU_ITEM mi
WHERE NOT EXISTS (
    SELECT 1
    FROM MENU_CHANGE_LOG mcl
    WHERE mcl.menu_item_id = mi.menu_item_id
    AND EXTRACT(YEAR FROM mcl.change_date) = 2026
);
```

![תוצאת שאילתה 4](./Stage%20B/Screenshots/Select_4_VersA.png)

**גרסה ב' (LEFT JOIN / IS NULL):**

```sql
SELECT mi.item_name, mi.added_date, mi.price
FROM MENU_ITEM mi
LEFT JOIN MENU_CHANGE_LOG mcl ON mi.menu_item_id = mcl.menu_item_id
    AND EXTRACT(YEAR FROM mcl.change_date) = 2026
WHERE mcl.change_id IS NULL;
```

![תוצאת שאילתה 4](./Stage%20B/Screenshots/Select_4_VersB.png)

**השוואת יעילות:** **גרסה א' (NOT EXISTS)** מהירה יותר ב-PostgreSQL כי היא משתמשת בלוגיקת "Anti-Join". המנוע מפסיק לחפש פריט ספציפי ברגע שמוצאת עבורו רשומת יומן ראשונה מ-2026. גרסה ב' חייבת להצטרף לכל הפריטים עם כל הרשומות תחילה לפני הסינון, תוך שימוש בזיכרון ומעבד רב יותר.

---

## 📊 שאילתות SELECT נוספות

### שאילתה 5: סטטיסטיקות עדכון חודשיות

**מה היא עושה:** סופרת את סך השינויים בתפריט שבוצעו בכל חודש בשנת 2024 כדי לעזור להנהלה להבין את התפלגות עומס העבודה.

```sql
SELECT EXTRACT(MONTH FROM change_date) AS month_num,
       TO_CHAR(change_date, 'Month') AS month_name,
       COUNT(*) AS updates_count
FROM MENU_CHANGE_LOG
WHERE EXTRACT(YEAR FROM change_date) = 2024
GROUP BY month_num, month_name
ORDER BY month_num;
```

![תוצאת שאילתה 5](./Stage%20B/Screenshots/Select_5.png)

### שאילתה 6: גיליון טכני של השף

**מה היא עושה:** מחברת ארבע טבלאות להפקת מדריך בישול מפורט הכולל שם הפריט, הוראות הכנה, מרכיבים ספציפיים וכמויות עבור כל המנות הזולות הזמינות.

```sql
SELECT mi.item_name, r.instructions, i.ingredient_name, ri.quantity, i.unit
FROM MENU_ITEM mi
JOIN RECIPE r ON mi.menu_item_id = r.menu_item_id
JOIN RECIPE_INGREDIENT ri ON r.recipe_id = ri.recipe_id
JOIN INGREDIENT i ON ri.ingredient_id = i.ingredient_id
WHERE mi.is_available = TRUE AND mi.price < 30
ORDER BY mi.item_name;
```

![תוצאת שאילתה 6](./Stage%20B/Screenshots/Select_6.png)

### שאילתה 7: דוח קטגוריות עתירות קלוריות

**מה היא עושה:** מדרגת קטגוריות תפריט לפי תכולת הקלוריות הממוצעת של המנות שלהן, ומספקת נתונים לעיצוב אפשרויות תפריט בריאותיות יותר.

```sql
SELECT mc.category_name,
       ROUND(AVG(mi.calories), 0) AS avg_calories,
       COUNT(mi.menu_item_id) AS total_items
FROM MENU_CATEGORY mc
JOIN MENU_ITEM mi ON mc.category_id = mi.category_id
WHERE mi.calories IS NOT NULL
GROUP BY mc.category_name
HAVING COUNT(mi.menu_item_id) >= 1
ORDER BY avg_calories DESC
LIMIT 5;
```

![תוצאת שאילתה 7](./Stage%20B/Screenshots/Select_7.png)

### שאילתה 8: ביקורת שינויי סוף שבוע

**מה היא עושה:** מפרטת את כל השינויים שבוצעו בימי שישי ושבת לניטור פעילות מנהלתית בסוף שבוע ועמידה בדרישות אבטחה.

```sql
SELECT mi.item_name, mcl.change_description,
       TO_CHAR(mcl.change_date, 'Day') AS day_name,
       mcl.change_date
FROM MENU_CHANGE_LOG mcl
JOIN MENU_ITEM mi ON mcl.menu_item_id = mi.menu_item_id
WHERE EXTRACT(DOW FROM mcl.change_date) IN (5, 6) -- 5=שישי, 6=שבת
ORDER BY mcl.change_date DESC;
```

![תוצאת שאילתה 8](./Stage%20B/Screenshots/Select_8.png)

---

## 🗑 שאילתות DELETE

### מחיקה 1: ארכוב יומן מנהלתי

**מה היא עושה:** מסירה רשומות יומן שינויים ישנות מעל שנתיים לשמירה על ביצועי מסד הנתונים ופינוי שטח אחסון.

```sql
DELETE FROM MENU_CHANGE_LOG
WHERE change_date < CURRENT_DATE - INTERVAL '2 years';
```

**לפני:**

![לפני מחיקה 1](./Stage%20B/Screenshots/Delete_1_Bef.png)

**אחרי:**

![אחרי מחיקה 1](./Stage%20B/Screenshots/Delete_1_Aft.png)

### מחיקה 2: ניקוי קטגוריות ריקות

**מה היא עושה:** מוחקת קטגוריות תפריט שאינן מכילות מנות כלשהן, ומבטיחה מבנה תפריט מסודר ולוגי.

```sql
DELETE FROM MENU_CATEGORY
WHERE category_id NOT IN (SELECT DISTINCT category_id FROM MENU_ITEM);
```

**לפני:**

![לפני מחיקה 2](./Stage%20B/Screenshots/Delete_2_Bef.png)

**אחרי:**

![אחרי מחיקה 2](./Stage%20B/Screenshots/Delete_2_Aft.png)

### מחיקה 3: פישוט מרכיבי מתכון

**מה היא עושה:** מסירה שורות מרכיבים ממתכונים שבהן הכמות הנדרשת קטנה מ-0.005, ומפשטת גיליונות טכניים לצוות המטבח.

```sql
DELETE FROM RECIPE_INGREDIENT
WHERE quantity < 0.005;
```

**לפני:**

![לפני מחיקה 3](./Stage%20B/Screenshots/Delete_3_Bef.png)

**אחרי:**

![אחרי מחיקה 3](./Stage%20B/Screenshots/Delete_3_Aft.png)

## ✏ שאילתות UPDATE

### עדכון 1: התאמת מחיר בגין אינפלציה בבקר

**מה היא עושה:** מעלה את המחיר ב-12% עבור כל המנות המכילות "בקר" כמרכיב במתכון שלהן, בתגובה לתנודות בעלויות השוק.

```sql
UPDATE MENU_ITEM
SET price = price * 1.12
WHERE menu_item_id IN (
    SELECT r.menu_item_id
    FROM RECIPE r
    JOIN RECIPE_INGREDIENT ri ON r.recipe_id = ri.recipe_id
    JOIN INGREDIENT i ON ri.ingredient_id = i.ingredient_id
    WHERE i.ingredient_name LIKE '%Beef%'
);
```

**לפני:**

![לפני עדכון 1](./Stage%20B/Screenshots/Update_1_Bef.png)

**אחרי:**

![אחרי עדכון 1](./Stage%20B/Screenshots/Update_1_Aft.png)

### עדכון 2: ניקוי עונתי של זמינות BBQ

**מה היא עושה:** מגדיר is_available לערך False עבור כל הפריטים בקטגוריית BBQ שלא עודכנו למעלה משנתיים.

```sql
UPDATE MENU_ITEM
SET is_available = FALSE
WHERE category_id IN (SELECT category_id FROM MENU_CATEGORY WHERE category_name LIKE '%BBQ%')
AND added_date < CURRENT_DATE - INTERVAL '2 years';
```

**לפני:**

![לפני עדכון 2](./Stage%20B/Screenshots/Update_2_Bef.png)

**אחרי:**

![אחרי עדכון 2](./Stage%20B/Screenshots/Update_2_Aft.png)

### עדכון 3: נרמול תיאורי יומן בוקר

**מה היא עושה:** ממלא אוטומטית תיאורי יומן ריקים בהערת "בדיקת מערכת בוקר שגרתית" סטנדרטית עבור כל העדכונים שבוצעו לפני 10:00 בבוקר.

```sql
UPDATE MENU_CHANGE_LOG
SET change_description = 'Routine morning system check'
WHERE change_description IS NULL
AND EXTRACT(HOUR FROM change_date) < 10;
```

**לפני:**

![לפני עדכון 3](./Stage%20B/Screenshots/Update_3_Bef.png)

**אחרי:**

![אחרי עדכון 3](./Stage%20B/Screenshots/Update_3_Aft.png)

---

## 🛡 אילוצי מסד הנתונים ושינויים

### אילוץ 1: יחידות מידה סטנדרטיות

**מה הוא עושה:** משתמש ב-ALTER TABLE להגבלת עמודת ה-unit בטבלת Ingredient לרשימה מוגדרת מראש של יחידות קולינריות (ק"ג, גרם, מ"ל וכו'), ומונע שגיאות הקלדה בהזנת נתונים.

```sql
ALTER TABLE INGREDIENT ADD CONSTRAINT check_unit_standard
CHECK (unit IN ('kg', 'grams', 'ml', 'liters', 'pieces', 'oz'));
```

**בדיקת הפרה:**

```sql
INSERT INTO INGREDIENT (ingredient_name, unit)
VALUES ('Test Ingredient', 'box');
```

![שגיאת אילוץ 1](./Stage%20B/Screenshots/New_Constraint_1.png)

### אילוץ 2: תקרת מחיר בטיחותית (500$)

**מה הוא עושה:** מיישם תקרת מחיר של $500 לכל פריט תפריט למניעת שגיאות הקלדה קטסטרופליות (למשל, $1000 במקום $10.00).

```sql
ALTER TABLE MENU_ITEM ADD CONSTRAINT check_max_price CHECK (price < 500);
```

**בדיקת הפרה:**

```sql
INSERT INTO MENU_ITEM (item_name, price, is_available, added_date, category_id)
VALUES ('Gold Burger', 650.00, TRUE, CURRENT_DATE, 1);
```

![שגיאת אילוץ 2](./Stage%20B/Screenshots/New_Constraint_2.png)

### אילוץ 3: אורך מינימלי לשם פריט

**מה הוא עושה:** מבטיח שכל שם מנה בטבלת `MENU_ITEM` מורכב מלפחות 3 תווים. זה מונע הזנת מציני מקום לא תיאוריים (כמו "א" או "TBD") ושומר על תפריט לקוחות מקצועי.

```sql
ALTER TABLE MENU_ITEM ADD CONSTRAINT check_item_name_length CHECK (LENGTH(item_name) >= 3);
```

**בדיקת הפרה:**

```sql
INSERT INTO MENU_ITEM (item_name, price, is_available, added_date, category_id)
VALUES ('A', 15.00, TRUE, CURRENT_DATE, 1);
```

![שגיאת אילוץ 3](./Stage%20B/Screenshots/New_Constraint_3.png)

### אילוץ 4: אימות תאריך יומן היסטורי

**מה הוא עושה:** מאמת שאף רשומה ב-`MENU_CHANGE_LOG` אינה מתוארכת לפני ה-1 בינואר 2020 (שנת השקת המערכת). זה שומר על שלמות היסטורית על ידי מניעת רישום יומנים עם תאריכים בלתי אפשריים בטעות.

```sql
ALTER TABLE MENU_CHANGE_LOG ADD CONSTRAINT check_valid_log_date
CHECK (change_date >= '2020-01-01');
```

**בדיקת הפרה:**

```sql
INSERT INTO MENU_CHANGE_LOG (change_description, change_date, menu_item_id)
VALUES ('Legacy change', '1995-01-01', 1);
```

![שגיאת אילוץ 4](./Stage%20B/Screenshots/New_Constraint_4.png)

---

## 🔄 בקרת טרנזקציות (Rollback & Commit)

### 🔙 טרנזקציית ROLLBACK

**מה היא עושה:** מדגימה את השימוש בפקודת ROLLBACK לביטול שינויים שבוצעו במהלך טרנזקציה. זה מבטיח שלמות נתונים על ידי מתן אפשרות למשתמשים להשליך שינויים שגויים או לא רצויים לפני שנשמרים לצמיתות במסד הנתונים. הדוגמה שלנו: סימולציה של שגיאת מנהל - עלייה בלתי מכוונת של $50 בכל התפריט.

```sql
-- שלב 1: בדיקת בסיס - צפייה במחירים המקוריים של 5 הפריטים הראשונים
SELECT menu_item_id, item_name, price
FROM MENU_ITEM
ORDER BY menu_item_id
LIMIT 5;

-- שלב 2: התחלת הטרנזקציה
BEGIN;

-- שלב 3: סימולציית השגיאה (עלייה בלתי מכוונת במחיר)
UPDATE MENU_ITEM
SET price = price + 50;

-- שלב 4: אימות המצב "המשונה"
-- המחירים כעת מנופחים.
SELECT menu_item_id, item_name, price
FROM MENU_ITEM
ORDER BY menu_item_id
LIMIT 5;

-- שלב 5: ביטול הטרנזקציה והחזרת השינויים
ROLLBACK;

-- שלב 6: אימות סופי - בדיקה שהמחירים חזרו לערכיהם המקוריים
SELECT menu_item_id, item_name, price
FROM MENU_ITEM
ORDER BY menu_item_id
LIMIT 5;
```

**מצב מקורי:** - _המחירים תקינים._

![הוכחת Rollback](./Stage%20B/Screenshots/Rollback_1.png)

**מצב לאחר UPDATE (לפני ROLLBACK):** - _המחירים מנופחים._

![הוכחת Rollback](./Stage%20B/Screenshots/Rollback_2.png)

**לאחר ROLLBACK:** - _המחירים חזרו לנורמה._

![הוכחת Rollback](./Stage%20B/Screenshots/Rollback_3.png)

### ✅ טרנזקציית COMMIT

**מה היא עושה:** מדגימה את השימוש בפקודת COMMIT לשמירת שינויים שבוצעו במהלך טרנזקציה במסד הנתונים. הדוגמה שלנו: ההנהלה מיישמת התאמת +100 קלוריות קבועה לעדכונים תזונתיים.

```sql
-- שלב 1: בדיקת בסיס - צפייה בספירות קלוריות הנוכחיות של 5 הפריטים הראשונים
SELECT menu_item_id, item_name, calories
FROM MENU_ITEM
WHERE calories IS NOT NULL
ORDER BY menu_item_id
LIMIT 5;

-- שלב 2: התחלת הטרנזקציה
BEGIN;

-- שלב 3: החלת העדכון (התאמה תזונתית)
UPDATE MENU_ITEM
SET calories = calories + 100
WHERE calories IS NOT NULL;

-- שלב 4: אימות המצב "המשונה" בתוך הטרנזקציה
SELECT menu_item_id, item_name, calories
FROM MENU_ITEM
WHERE calories IS NOT NULL
ORDER BY menu_item_id
LIMIT 5;

-- שלב 5: שמירת השינויים לצמיתות במסד הנתונים
COMMIT;

-- שלב 6: אימות סופי - אישור שהתאמת +100 הקלוריות נשמרת
SELECT menu_item_id, item_name, calories
FROM MENU_ITEM
WHERE calories IS NOT NULL
ORDER BY menu_item_id
LIMIT 5;
```

**מצב מקורי:** - _ספירות קלוריות תקינות._

![הוכחת Commit](./Stage%20B/Screenshots/Commit_1.png)

**מצב לאחר UPDATE (לפני COMMIT):** - _ספירות קלוריות מוגדלות._

![הוכחת Commit](./Stage%20B/Screenshots/Commit_2.png)

**לאחר COMMIT:** - _השינויים נשמרו לצמיתות במסד הנתונים._

![הוכחת Commit](./Stage%20B/Screenshots/Commit_3.png)

---

## 💾 גיבוי ושחזור - שלב ב'

גיבוי סופי של השלב בפורמט `.tar`.

![גיבוי 2](./Stage%20B/Screenshots/Backup2.png)

---

# 🔗 שלב ג': אינטגרציה ומבטים

## 🧩 סקירת האינטגרציה

בשלב זה ביצענו **אינטגרציה לפי שיטה א' (איחוד / Fusion)**. קיבלנו גיבוי של מערכת של זוג אחר – **מחלקת המטבח (Kitchen Operations)** – ואיחדנו אותה עם המערכת שלנו – **מחלקת ניהול התפריט (Menu Management)** – לכדי בסיס נתונים משולב אחד.

שתי המחלקות משלימות זו את זו בעולם האמיתי: המחלקה שלנו מגדירה **אילו מנות קיימות** (תפריט, מתכונים, מרכיבים), ואילו מחלקת המטבח מתעדת את **הביצוע בפועל** (אילו טבחים הכינו מנות, באילו עמדות, ביקורות היגיינה). 

המערכת שהתקבלה כוללת **6 ישויות**:

| טבלה | תיאור |
|---|---|
| `kitchen_station` | עמדות עבודה במטבח |
| `chef` | טבחים (כולל תאריך גיוס ושיוך לעמדה) |
| `kitchen_order` | הזמנות מטבח |
| `food_prep_log` | יומן הכנת מנות (20,000+ רשומות) |
| `hygiene_inspection` | ביקורות היגיינה |
| `preparation_task` | משימות הכנה |

---

## 🔄 אלגוריתם הינדוס לאחור

מתוך הגיבוי שקיבלנו (קובץ `.sql` עם פקודות `CREATE TABLE` ונתונים) שחזרנו את ה-DSD, וממנו ביצענו **הינדוס לאחור (Reverse Engineering)** כדי לקבל את ה-ERD. האלגוריתם:

```
קלט  : אוסף טבלאות עם עמודות, מפתחות ראשיים (PK) ומפתחות זרים (FK).
פלט  : תרשים ERD (ישויות, מאפיינים, קשרים, מונים).

שלב 1 — סיווג כל טבלה:
  (א) טבלת קשר (M:N):
       אם ה-PK מורכב כולו מ-FK (שני FK או יותר)
       => אין זו ישות, אלא קשר M:N.
  (ב) ישות חלשה:
       אם ה-PK כולל FK לטבלה אחרת (מפתח מושאל חלקית)
       => ישות חלשה, מחוברת בקשר מזהה.
  (ג) ישות חזקה:
       אחרת (PK = מזהה עצמאי) => ישות חזקה.

שלב 2 — יצירת ישות לכל טבלה מסוג (ב) ו-(ג).
        העמודות שאינן FK הופכות למאפיינים; ה-PK הופך למזהה.

שלב 3 — טיפול ב-FK שאינם חלק מה-PK:
        כל FK = קשר 1:N. צד "1" = הטבלה המוצבעת; צד "N" = הטבלה עם ה-FK.

שלב 4 — טיפול בטבלאות קשר (1א):
        יצירת קשר M:N בין הישויות; עמודות שנותרו = מאפייני הקשר.

שלב 5 — קביעת מונים / השתתפות:
        FK NOT NULL => השתתפות מלאה.  FK nullable => השתתפות חלקית.
        FK UNIQUE  => הקשר הופך ל-1:1.

שלב 6 — מתן שם משמעותי (פועל) לכל קשר.
```

**תוצאת היישום:** בכל 6 הטבלאות של המחלקה שהתקבלה ה-PK הוא מזהה עצמאי, אין PK המורכב מ-FK ואין PK מושאל. לכן המסקנה: **6 ישויות חזקות המחוברות ב-7 קשרי 1:N**, ללא קשרי M:N וללא ישויות חלשות (בניגוד למערכת שלנו, שבה קיימת ישות חלשה `RECIPE` וטבלת קשר `RECIPE_INGREDIENT`).

---

## 🖼 דיאגרמות שלב ג'

**DSD של האגף החדש (מטבח):**

![DSD מטבח](./Stage%20C/DSD_kitchen_received.png)

**ERD של האגף החדש (תוצאת ההינדוס לאחור):**

![ERD מטבח](./Stage%20C/ERD_kitchen_received.png)

**ERD משותף (לאחר האינטגרציה - 12 ישויות):**

![ERD משותף](./Stage%20C/ERD_integrated.png)

**DSD לאחר האינטגרציה:**

![DSD משולב](./Stage%20C/DSD_after_integration.png)

---

## 🧠 החלטות בשלב האינטגרציה

1. **נקודת החיבור = `MENU_ITEM`.** שתי המחלקות חולקות את המושג "מנה". בטבלת `food_prep_log` שהתקבלה, העמודה `menu_item_id` הייתה מספר חופשי **ללא FK** שהצביע על מנה שלא קיימת אצלם. זוהי נקודת החיבור הסמנטית היחידה והטבעית.
2. **אין מיזוג ישויות.** המחלקות משלימות (עיצוב תפריט מול ביצוע במטבח) ולא חופפות, לכן כל 12 הישויות נשמרות.
3. **אין התנגשות שמות.** הטבלאות שלנו (`menu_*`, `recipe*`, `ingredient`) והטבלאות שלהם (`kitchen_*`, `chef`, `food_prep_log` וכו') בעלות שמות שונים – אין צורך בשינוי שם.
4. **`kitchen_order.order_id` נשאר מאפיין חופשי.** הוא מצביע על הזמנת לקוח, מושג שאינו קיים באף אחת מהמחלקות – לכן אין גשר אפשרי מצד זה.
5. **שיטות יצירת מפתחות נשמרות.** הטבלאות שלנו משתמשות ב-`SERIAL` ושלהם ב-`GENERATED BY DEFAULT AS IDENTITY` – כל אחת נשמרת כפי שהיא.
6. **התאמת נתונים (Reconciliation).** נדרש שכל `menu_item_id` ב-`food_prep_log` יצביע על מנה קיימת ב-`MENU_ITEM` שלנו, אחרת יצירת ה-FK תיכשל. בדיקה: `MENU_ITEM` שלנו מכיל מזהים `1..500`, ואילו `food_prep_log.menu_item_id` נע בטווח `1..100` בלבד. לכן **כל ההפניות תקינות** ולא נדרשה התאמה – שאילתת האימות החזירה `orphan_menu_item_refs = 0`.
7. **ייצוג הקשר 1:1 בין `RECIPE` ל-`MENU_ITEM`.** הקשר 1:1 בין `RECIPE` ל-`MENU_ITEM` ממומש במציאות עם המפתח הזר `menu_item_id` בטבלת `RECIPE` (מוגדר `NOT NULL UNIQUE`). בכלי ERDPlus, עקב מגבלת הכלי, אותו קשר מוצג עם המפתח הזר בצד של `MENU_ITEM` – שתי הצורות שקולות לחלוטין עבור קשר 1:1, ומייצגות את אותו אילוץ "אחד-לאחד".

---

## ⚙ תהליך האינטגרציה והפקודות

האינטגרציה בוצעה בשני שלבים, **ללא יצירה מחדש של אף טבלה קיימת** (כנדרש):

**1. שחזור הגיבוי שהתקבל אל תוך בסיס הנתונים הקיים.** הקובץ המקורי היה בקידוד UTF-16 והכיל פקודות `OWNER TO "myUser"` (תפקיד שאינו קיים אצלנו). לכן המרנו אותו ל-UTF-8 והסרנו את שורות ה-`OWNER`, ואז שחזרנו:

```bash
docker cp backup_kitchen_utf8.sql PostgreSQL_DB:/tmp/kitchen.sql
docker exec PostgreSQL_DB psql -U MyUser -d DB5786David -f /tmp/kitchen.sql
```

לאחר השחזור התקבלו **12 טבלאות** המתקיימות זו לצד זו (6 תפריט + 6 מטבח), כולל `food_prep_log` עם 20,010 רשומות.

**2. הרצת `Integrate.sql`** – יצירת **הגשר** באמצעות פקודות `ALTER TABLE` בלבד:

```sql
-- הפיכת menu_item_id ל-FK אמיתי המצביע על התפריט שלנו
ALTER TABLE food_prep_log
    ADD CONSTRAINT fk_food_prep_log_menu_item
    FOREIGN KEY (menu_item_id) REFERENCES menu_item (menu_item_id)
    ON DELETE CASCADE;

ALTER TABLE food_prep_log ALTER COLUMN menu_item_id SET NOT NULL;

CREATE INDEX idx_food_prep_log_menu_item ON food_prep_log (menu_item_id);
```

נבחר `ON DELETE CASCADE` לעקביות עם טבלת היומן הקיימת שלנו (`menu_change_log`): כאשר מנה נמחקת מהתפריט, גם רשומות ההכנה הקשורות אליה במטבח נמחקות.

**אימות לאחר האינטגרציה:** כל 12 הטבלאות קיימות, והאילוץ `fk_food_prep_log_menu_item` נוצר בהצלחה. בנוסף, **כל שאילתות שלב ב' הורצו מחדש על בסיס הנתונים המשולב ופעלו ללא תקלות** (8 שאילתות SELECT + 3 DELETE + 3 UPDATE, האחרונות בתוך טרנזקציה עם ROLLBACK כדי לא לשנות נתונים).

---

## 👁 מבטים

נכתבו **שני מבטים**, אחד מנקודת המבט של כל מחלקה מקורית. שני המבטים משלבים 3 טבלאות, והמבט הראשון מנצל את **גשר האינטגרציה**.

### מבט 1 (נקודת מבט: ניהול התפריט) — `v_menu_kitchen_activity`

**תיאור:** עבור כל מנה בתפריט, המבט מציג כיצד המטבח משתמש בה בפועל – כמה פעמים הוכנה, זמן ההכנה הממוצע ותאריך ההכנה האחרון, יחד עם הקטגוריה והמחיר. שימוש ב-`LEFT JOIN` כך שגם מנות שמעולם לא הוכנו מופיעות (עם 0). משלב את `menu_item` + `menu_category` + `food_prep_log` (הגשר).

```sql
CREATE OR REPLACE VIEW v_menu_kitchen_activity AS
SELECT mi.menu_item_id, mi.item_name, mc.category_name, mi.price, mi.is_available,
       COUNT(fpl.log_id) AS times_prepared,
       ROUND(AVG(fpl.preparation_time), 1) AS avg_prep_time,
       MAX(fpl.prep_date) AS last_prepared
FROM menu_item mi
JOIN menu_category mc ON mi.category_id = mc.category_id
LEFT JOIN food_prep_log fpl ON fpl.menu_item_id = mi.menu_item_id
GROUP BY mi.menu_item_id, mi.item_name, mc.category_name, mi.price, mi.is_available;
```

**שליפת `SELECT *` (10 רשומות):**

```text
 menu_item_id |          item_name          |        category_name        | price  | is_available | times_prepared | avg_prep_time | last_prepared
--------------+-----------------------------+-----------------------------+--------+--------------+----------------+---------------+---------------
            1 | Table Cloth 90x90 White 1   | Dips & Spreads 68           | 107.77 | f            |            209 |          58.7 | 2026-02-24
            2 | Green Scrubbie Pad H.duty 2 | Baking Ingredients 308      |  23.70 | f            |            174 |          60.1 | 2026-02-28
            3 | Bread Base - Goodhearth 3   | Specialty Grains 125        |  79.03 | t            |            187 |          62.1 | 2026-02-28
            4 | Longos - Lasagna Beef 4     | Home Appliances 395         |  11.24 | f            |            223 |          64.8 | 2026-02-25
            5 | Creme De Cacao Mcguines 5   | Solar Power Accessories 264 |  34.17 | f            |            194 |          60.1 | 2026-02-28
            6 | Nut - Walnut, Chopped 6     | Camping Equipment 183       |  13.29 | f            |            193 |          67.7 | 2026-02-28
            7 | Glass Clear 8 Oz 7          | Car Cleaning 339            |  12.42 | t            |            198 |          60.7 | 2026-02-27
            8 | Tea - Herbal Orange Spice 8 | Fresh Mushrooms 237         |  39.76 | f            |            189 |          60.0 | 2026-02-27
            9 | Versatainer Nc - 888 9      | Whole Grain Breads 198      |  43.58 | f            |            193 |          64.5 | 2026-02-24
           10 | Chambord Royal 10           | Savory Breakfast Options 28 |  61.98 | f            |            184 |          59.7 | 2026-02-27
```

**שאילתא 1 על המבט — 10 המנות המוכנות ביותר:**

```sql
SELECT item_name, category_name, times_prepared, avg_prep_time
FROM v_menu_kitchen_activity
ORDER BY times_prepared DESC
LIMIT 10;
```

```text
            item_name            |     category_name      | times_prepared | avg_prep_time
---------------------------------+------------------------+----------------+---------------
 Soup Campbells Turkey Veg. 72   | Healthy Snacks 444     |            237 |          59.1
 Muffin Carrot - Individual 41   | Dairy Spreads 202      |            229 |          56.8
 Cheese - Le Cheve Noir 11       | Mobile Accessories 151 |            228 |          61.8
 Flour - Semolina 36             | Journals 423           |            227 |          61.4
 Mousse - Mango 86               | Frozen Meals 485       |            226 |          59.7
 ...
```

**שאילתא 2 על המבט — מנות זמינות שמעולם לא הוכנו (מועמדות להסרה מהתפריט):**

```sql
SELECT item_name, category_name, price
FROM v_menu_kitchen_activity
WHERE times_prepared = 0 AND is_available = TRUE
ORDER BY price DESC
LIMIT 10;
```

```text
             item_name             |         category_name          | price
-----------------------------------+--------------------------------+--------
 Cheese - Mozzarella, Shredded 210 | Frozen Vegan Meals 175         | 111.85
 Wine - Chardonnay Mondavi 114     | Healthy Snacks 444             | 111.33
 Tabasco Sauce, 2 Oz 243           | Salsas and Dips 51             | 111.05
 ...
```

### מבט 2 (נקודת מבט: תפעול המטבח) — `v_chef_workload`

**תיאור:** עבור כל טבח, המבט מציג את עומס העבודה שלו – העמדה המשויכת, סטטוס המשמרת, מספר ההכנות שתועדו וזמן ההכנה הממוצע. משלב את `chef` + `kitchen_station` + `food_prep_log`.

```sql
CREATE OR REPLACE VIEW v_chef_workload AS
SELECT c.chef_id, c.first_name || ' ' || c.last_name AS chef_name,
       c.specialization, ks.station_name, c.is_on_shift,
       COUNT(fpl.log_id) AS total_preparations,
       ROUND(AVG(fpl.preparation_time), 1) AS avg_prep_time
FROM chef c
LEFT JOIN kitchen_station ks ON c.current_station_id = ks.station_id
LEFT JOIN food_prep_log fpl ON fpl.chef_id = c.chef_id
GROUP BY c.chef_id, c.first_name, c.last_name, c.specialization, ks.station_name, c.is_on_shift;
```

**שליפת `SELECT *` (10 רשומות):**

```text
 chef_id |            chef_name            | specialization |   station_name   | is_on_shift | total_preparations | avg_prep_time
---------+---------------------------------+----------------+------------------+-------------+--------------------+---------------
       1 | Clerissa Fallanche              | Butcher        | Saute Station    | t           |                418 |          63.3
       2 | Norby Grice                     | Poissonnier    | Grill Station    | f           |                388 |          63.5
       3 | De witt Murricanes              | Saucier        | Butcher Station  | f           |                402 |          63.2
       4 | Kore Bowdrey                    | Butcher        | Deep Fry Station | f           |                401 |          61.1
       5 | Mattias Sponer                  | Line Cook      | Pasta Station    | f           |                380 |          59.3
       6 | Luise Aumerle                   | Executive Chef | Soup Station     | f           |                401 |          62.3
       7 | Cornie Howick                   | Line Cook      | Grill Station    | t           |                430 |          60.8
       8 | Ailee Le Breton De La Vieuville | Barista        | Sushi Station    | t           |                429 |          60.9
       9 | Emlyn Vanetti                   | Saucier        | Butcher Station  | f           |                374 |          65.0
      10 | Hadlee Jeandillou               | Butcher        | Pastry Station   | t           |                382 |          61.1
```

**שאילתא 1 על המבט — 10 הטבחים העמוסים ביותר:**

```sql
SELECT chef_name, station_name, total_preparations, avg_prep_time
FROM v_chef_workload
ORDER BY total_preparations DESC
LIMIT 10;
```

```text
            chef_name            |  station_name   | total_preparations | avg_prep_time
---------------------------------+-----------------+--------------------+---------------
 Norean Ocklin                   | Pastry Station  |                448 |          59.3
 Edyth Alliker                   | Sushi Station   |                439 |          58.2
 Cornie Howick                   | Grill Station   |                430 |          60.8
 Reece MacLoughlin               | Pasta Station   |                430 |          62.6
 Dewain Epp                      | Plating Station |                430 |          61.8
 ...
```

**שאילתא 2 על המבט — עומס כולל לפי עמדה (מספר טבחים וסך ההכנות):**

```sql
SELECT station_name, COUNT(*) AS chefs_count,
       SUM(total_preparations) AS station_total_preparations
FROM v_chef_workload
WHERE station_name IS NOT NULL
GROUP BY station_name
ORDER BY station_total_preparations DESC;
```

```text
   station_name   | chefs_count | station_total_preparations
------------------+-------------+----------------------------
 Grill Station    |           6 |                       2445
 Plating Station  |           8 |                       2424
 Pasta Station    |           7 |                       2377
 Beverage Station |           7 |                       2364
 ...
 Pizza Station    |           1 |                          0
```

---

## 💾 גיבוי - שלב ג'

גיבוי מעודכן של בסיס הנתונים **המשולב** (12 טבלאות + הגשר) נשמר בפורמט `.tar` בשם `backup3`.

```bash
docker exec PostgreSQL_DB pg_dump -U MyUser -d DB5786David -F t -f /tmp/backup3.tar
```

![גיבוי 3](./Stage%20C/Screenshots/Backup3.png)

---

# 🧬 שלב ד': תכנות (PL/pgSQL)

## 💡 סקירת התכנות

בשלב זה כתבנו תוכניות PL/pgSQL על בסיס הנתונים **המורחב** (12 הטבלאות משלב ג'). נכתבו **2 פונקציות, 2 פרוצדורות, 2 טריגרים (אחד לפחות על UPDATE) ו-2 תוכניות ראשיות** המזמנות כל אחת פונקציה ופרוצדורה. התוכניות מנצלות את גשר האינטגרציה (`food_prep_log.menu_item_id → menu_item`) ומשלבות את כל אלמנטי התכנות הנדרשים: **קורסור implicit ו-explicit, החזרת Ref Cursor, פקודות DML, הסתעפויות, לולאות, חריגות (Exception) ורשומות (Records)**.

| קובץ | סוג | אלמנטים עיקריים |
|---|---|---|
| `fn_menu_item_kitchen_stats.sql` | פונקציה | Record, implicit cursor, הסתעפות, Exception |
| `fn_get_chef_preparations.sql` | פונקציה | Ref Cursor, Exception |
| `sp_apply_category_price_increase.sql` | פרוצדורה | DML (UPDATE), הסתעפות, Exception |
| `sp_archive_old_prep_logs.sql` | פרוצדורה | Explicit cursor, לולאה, DML (DELETE), Exception |
| `trg_log_price_change.sql` | טריגר (UPDATE) | DML (INSERT), הסתעפות, OLD/NEW |
| `trg_maintain_times_prepared.sql` | טריגר (INSERT/DELETE) | הסתעפות TG_OP, DML (UPDATE) |
| `main_program_1.sql` | תוכנית ראשית | מזמנת פרוצדורה + פונקציה |
| `main_program_2.sql` | תוכנית ראשית | מזמנת פרוצדורה + פונקציה (Ref Cursor) |

---

## 🔧 שינוי טבלאות - AlterTable

לצורך התוכניות הוספנו עמודת מונה `times_prepared` לטבלת `menu_item`, המתוחזקת אוטומטית על ידי הטריגר `trg_maintain_times_prepared`. כל השינויים נשמרו בקובץ `AlterTable.sql`:

```sql
ALTER TABLE menu_item ADD COLUMN IF NOT EXISTS times_prepared INTEGER NOT NULL DEFAULT 0;

UPDATE menu_item mi
SET times_prepared = COALESCE((SELECT COUNT(*) FROM food_prep_log f
                               WHERE f.menu_item_id = mi.menu_item_id), 0);

ALTER TABLE menu_item ADD CONSTRAINT chk_times_prepared_non_negative CHECK (times_prepared >= 0);
```

הרצה: `ALTER TABLE` + `UPDATE 500` (אכלוס המונה לכל 500 הפריטים).

---

## ⚙ פונקציות

### פונקציה 1 — `fn_menu_item_kitchen_stats(p_menu_item_id)`

**תיאור:** עבור פריט תפריט נתון, מחזירה "כרטיס" המשלב נתוני תפריט (שם, קטגוריה, מחיר) עם נתוני מטבח (כמה פעמים הוכן, זמן הכנה ממוצע) ותווית פופולריות מחושבת. משתמשת ב-**Record**, ב-**implicit cursor** (SELECT INTO), ב-**הסתעפות** לקביעת הפופולריות, וזורקת **Exception** אם הפריט אינו קיים.

```sql
CREATE OR REPLACE FUNCTION fn_menu_item_kitchen_stats(p_menu_item_id INTEGER)
RETURNS TABLE (item_name VARCHAR, category_name VARCHAR, price NUMERIC,
               times_prepared INTEGER, avg_prep_time NUMERIC, popularity_label TEXT)
LANGUAGE plpgsql AS $$
DECLARE rec RECORD; v_label TEXT;
BEGIN
    SELECT mi.item_name, mc.category_name, mi.price, mi.times_prepared,
           ROUND(AVG(f.preparation_time), 1) AS avg_pt
    INTO rec
    FROM menu_item mi
    JOIN menu_category mc ON mi.category_id = mc.category_id
    LEFT JOIN food_prep_log f ON f.menu_item_id = mi.menu_item_id
    WHERE mi.menu_item_id = p_menu_item_id
    GROUP BY mi.item_name, mc.category_name, mi.price, mi.times_prepared;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Menu item % does not exist', p_menu_item_id;
    END IF;

    IF rec.times_prepared = 0 THEN v_label := 'Never prepared';
    ELSIF rec.times_prepared < 100 THEN v_label := 'Low';
    ELSIF rec.times_prepared < 200 THEN v_label := 'Medium';
    ELSE v_label := 'High'; END IF;

    RETURN QUERY SELECT rec.item_name, rec.category_name, rec.price,
                        rec.times_prepared, rec.avg_pt, v_label;
END; $$;
```

**הוכחת הרצה — קריאה תקינה:**
```text
SELECT * FROM fn_menu_item_kitchen_stats(1);

         item_name         |   category_name   | price  | times_prepared | avg_prep_time | popularity_label
---------------------------+-------------------+--------+----------------+---------------+------------------
 Table Cloth 90x90 White 1 | Dips & Spreads 68 | 107.77 |            209 |          58.7 | High
```

**הוכחת הרצה — זריקת חריגה (פריט לא קיים):**
```text
SELECT * FROM fn_menu_item_kitchen_stats(999999);

ERROR:  Menu item 999999 does not exist
CONTEXT: PL/pgSQL function fn_menu_item_kitchen_stats(integer) line 21 at RAISE
```

### פונקציה 2 — `fn_get_chef_preparations(p_chef_id)`

**תיאור:** מחזירה **Ref Cursor** על כל ההכנות שתועדו על ידי טבח נתון, מועשר בשמות המנות (גשר מטבח↔תפריט). זורקת **Exception** אם הטבח אינו קיים.

```sql
CREATE OR REPLACE FUNCTION fn_get_chef_preparations(p_chef_id INTEGER)
RETURNS refcursor
LANGUAGE plpgsql AS $$
DECLARE v_exists BOOLEAN; v_cursor refcursor := 'chef_prep_cursor';
BEGIN
    SELECT EXISTS (SELECT 1 FROM chef WHERE chef_id = p_chef_id) INTO v_exists;
    IF NOT v_exists THEN
        RAISE EXCEPTION 'Chef % does not exist', p_chef_id;
    END IF;

    OPEN v_cursor FOR
        SELECT f.log_id, mi.item_name, f.preparation_time, f.prep_date
        FROM food_prep_log f
        JOIN menu_item mi ON mi.menu_item_id = f.menu_item_id
        WHERE f.chef_id = p_chef_id
        ORDER BY f.prep_date DESC;
    RETURN v_cursor;
END; $$;
```

**הוכחת הרצה (באותה טרנזקציה):**
```text
BEGIN;
SELECT fn_get_chef_preparations(1);   -- מחזיר 'chef_prep_cursor'
FETCH 5 IN chef_prep_cursor;

 log_id |            item_name            | preparation_time | prep_date
--------+---------------------------------+------------------+------------
  14504 | Milk - Condensed 34             |               58 | 2026-02-27
  13411 | Chinese Foods - Chicken Wing 23 |               38 | 2026-02-26
  17259 | Sauce - Soya, Light 87          |                6 | 2026-02-25
  12822 | Sardines 55                     |               80 | 2026-02-25
   9220 | Bread - Bagels, Plain 52        |               97 | 2026-02-25
```

---

## ⚙ פרוצדורות

### פרוצדורה 1 — `sp_apply_category_price_increase(p_category_id, p_percent)`

**תיאור:** מעלה את מחירי כל פריטי קטגוריה נתונה באחוז מסוים. כוללת **ולידציה + הסתעפות + Exception** (אחוז לא תקין / קטגוריה לא קיימת), פקודת **DML (UPDATE)**, ומדווחת כמה שורות עודכנו. כל עדכון מחיר מפעיל גם את הטריגר `trg_log_price_change`.

```sql
CREATE OR REPLACE PROCEDURE sp_apply_category_price_increase(
    p_category_id INTEGER, p_percent NUMERIC)
LANGUAGE plpgsql AS $$
DECLARE v_cat_name VARCHAR; v_count INTEGER;
BEGIN
    IF p_percent <= 0 OR p_percent > 100 THEN
        RAISE EXCEPTION 'Invalid percent %, must be between 0 and 100', p_percent;
    END IF;
    SELECT category_name INTO v_cat_name FROM menu_category WHERE category_id = p_category_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Category % does not exist', p_category_id;
    END IF;
    UPDATE menu_item SET price = ROUND(price * (1 + p_percent / 100.0), 2)
    WHERE category_id = p_category_id;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    RAISE NOTICE 'Applied % percent increase to % item(s) in category "%"',
                 p_percent, v_count, v_cat_name;
END; $$;
```

**הוכחת הרצה (כולל הוכחת הטריגר `trg_log_price_change` שנכנס לפעולה):**
```text
CALL sp_apply_category_price_increase(68, 10);
NOTICE:  Applied 10 percent increase to 3 item(s) in category "Dips & Spreads 68"

SELECT change_description FROM menu_change_log WHERE menu_item_id=1 ORDER BY change_id DESC LIMIT 2;
          change_description
--------------------------------------
 Price changed from 107.77 to 118.55     <-- נוצר אוטומטית על ידי הטריגר
 Changed display name on digital menu
```

### פרוצדורה 2 — `sp_archive_old_prep_logs(p_cutoff_date)`

**תיאור:** מוחקת (מארכבת) את כל רשומות `food_prep_log` הישנות מתאריך חתך, באמצעות **קורסור explicit** המוגדר `FOR UPDATE`, **לולאה**, ופקודת **DML (DELETE ... WHERE CURRENT OF)**. כוללת **Exception block** עם re-raise. כל מחיקה מפעילה את הטריגר `trg_maintain_times_prepared`.

```sql
CREATE OR REPLACE PROCEDURE sp_archive_old_prep_logs(p_cutoff_date DATE)
LANGUAGE plpgsql AS $$
DECLARE
    cur_old CURSOR FOR
        SELECT log_id, menu_item_id, prep_date FROM food_prep_log
        WHERE prep_date < p_cutoff_date FOR UPDATE;
    rec RECORD; v_deleted INTEGER := 0;
BEGIN
    IF p_cutoff_date > CURRENT_DATE THEN
        RAISE EXCEPTION 'Cutoff date % cannot be in the future', p_cutoff_date;
    END IF;
    OPEN cur_old;
    LOOP
        FETCH cur_old INTO rec;
        EXIT WHEN NOT FOUND;
        DELETE FROM food_prep_log WHERE CURRENT OF cur_old;
        v_deleted := v_deleted + 1;
    END LOOP;
    CLOSE cur_old;
    RAISE NOTICE 'Archived (deleted) % preparation log(s) older than %', v_deleted, p_cutoff_date;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Error during archive: %', SQLERRM;
    RAISE;
END; $$;
```

**הוכחת הרצה (בתוך טרנזקציה עם ROLLBACK כדי לא לפגוע בנתונים):**
```text
BEGIN;
CALL sp_archive_old_prep_logs(DATE '2025-02-01');
NOTICE:  Archived (deleted) 1459 preparation log(s) older than 2025-02-01
ROLLBACK;
```

---

## ⚡ טריגרים

### טריגר 1 — `trg_log_price_change` (AFTER UPDATE על `menu_item`)

**תיאור:** טריגר החובה על UPDATE. בכל פעם שמחיר פריט תפריט מתעדכן, נרשמת אוטומטית שורת תיעוד ב-`menu_change_log` (מחיר ישן → חדש). משתמש ב-**הסתעפות** (רק כשהמחיר באמת השתנה), ב-**OLD/NEW**, ובפקודת **DML (INSERT)**.

```sql
CREATE OR REPLACE FUNCTION trg_fn_log_price_change()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF NEW.price IS DISTINCT FROM OLD.price THEN
        INSERT INTO menu_change_log (change_description, change_date, menu_item_id)
        VALUES (format('Price changed from %s to %s', OLD.price, NEW.price),
                CURRENT_TIMESTAMP, NEW.menu_item_id);
    END IF;
    RETURN NEW;
END; $$;

CREATE TRIGGER trg_log_price_change AFTER UPDATE ON menu_item
FOR EACH ROW EXECUTE FUNCTION trg_fn_log_price_change();
```

**הוכחת הרצה:** ראו את פלט פרוצדורה 1 לעיל — לאחר עדכון המחיר, נוצרה אוטומטית הרשומה `Price changed from 107.77 to 118.55` בטבלת `menu_change_log`. אימות במסד הנתונים (pgAdmin): השורה החדשה (`change_id 20005`) נוצרה על ידי הטריגר עם תאריך היום, ללא כתיבה ידנית.

![הוכחת הטריגר - לוג שינוי מחיר אוטומטי](./Stage%20D/Screenshots/picture_2.png)

### טריגר 2 — `trg_maintain_times_prepared` (AFTER INSERT/DELETE על `food_prep_log`)

**תיאור:** מתחזק את המונה `menu_item.times_prepared` בסנכרון עם יומן המטבח: הכנה חדשה → 1+ ; מחיקת רשומה → 1-. משתמש ב-**הסתעפות על `TG_OP`** ובפקודת **DML (UPDATE)**.

```sql
CREATE OR REPLACE FUNCTION trg_fn_maintain_times_prepared()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE menu_item SET times_prepared = times_prepared + 1
        WHERE menu_item_id = NEW.menu_item_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE menu_item SET times_prepared = times_prepared - 1
        WHERE menu_item_id = OLD.menu_item_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END; $$;

CREATE TRIGGER trg_maintain_times_prepared AFTER INSERT OR DELETE ON food_prep_log
FOR EACH ROW EXECUTE FUNCTION trg_fn_maintain_times_prepared();
```

**הוכחת הרצה (INSERT מגדיל את המונה, ואז ROLLBACK):**
```text
BEGIN;
SELECT times_prepared AS avant FROM menu_item WHERE menu_item_id=1;   -->  209
INSERT INTO food_prep_log (chef_id, menu_item_id, preparation_time, prep_date)
VALUES (1,1,30,CURRENT_DATE);
SELECT times_prepared AS apres FROM menu_item WHERE menu_item_id=1;    -->  210
ROLLBACK;
```

---

## 🚀 תוכניות ראשיות

### תוכנית ראשית 1 — `main_program_1.sql`

**תיאור:** מזמנת **פרוצדורה אחת + פונקציה אחת**: קודם `sp_apply_category_price_increase` (העלאת מחירי הקטגוריה של פריט 1 ב-10%), ואז `fn_menu_item_kitchen_stats` להצגת הכרטיס המעודכן של פריט 1.

```sql
DO $$
DECLARE v_item_id INTEGER := 1; v_cat_id INTEGER; rec RECORD;
BEGIN
    SELECT category_id INTO v_cat_id FROM menu_item WHERE menu_item_id = v_item_id;
    RAISE NOTICE '=== MAIN PROGRAM 1 : item % (category %) ===', v_item_id, v_cat_id;
    CALL sp_apply_category_price_increase(v_cat_id, 10);
    FOR rec IN SELECT * FROM fn_menu_item_kitchen_stats(v_item_id) LOOP
        RAISE NOTICE 'Item: % | Category: % | Price: % | Prepared % time(s) | Avg time: % | Popularity: %',
            rec.item_name, rec.category_name, rec.price, rec.times_prepared, rec.avg_prep_time, rec.popularity_label;
    END LOOP;
END; $$;
```

**הוכחת הרצה:**
```text
NOTICE:  === MAIN PROGRAM 1 : item 1 (category 68) ===
NOTICE:  Applied 10 percent increase to 3 item(s) in category "Dips & Spreads 68"
NOTICE:  Item: Table Cloth 90x90 White 1 | Category: Dips & Spreads 68 | Price: 118.55 | Prepared 209 time(s) | Avg time: 58.7 | Popularity: High
```

**אימות במסד הנתונים (pgAdmin):** המחיר של פריט 1 התעדכן ל-`118.55` (העלאה של 10% מ-107.77), והעמודה החדשה `times_prepared` מציגה 209 — הוכחה שהפרוצדורה והשינוי בסכמה אכן נשמרו בבסיס הנתונים.

![הוכחת השינוי במסד הנתונים - מחיר ומונה ההכנות](./Stage%20D/Screenshots/picture_1.png)

### תוכנית ראשית 2 — `main_program_2.sql`

**תיאור:** מזמנת **פרוצדורה אחת + פונקציה אחת**: קודם `sp_archive_old_prep_logs` (תאריך חתך ישן ובטוח), ואז צורכת את ה-**Ref Cursor** המוחזר מ-`fn_get_chef_preparations` ומדפיסה את 5 ההכנות הראשונות של טבח 1.

```sql
DO $$
DECLARE v_cursor refcursor; rec RECORD; v_count INTEGER := 0;
BEGIN
    RAISE NOTICE '=== MAIN PROGRAM 2 : archive old logs + chef #1 preparations ===';
    CALL sp_archive_old_prep_logs(DATE '2024-01-01');
    v_cursor := fn_get_chef_preparations(1);
    LOOP
        FETCH v_cursor INTO rec;
        EXIT WHEN NOT FOUND;
        v_count := v_count + 1;
        RAISE NOTICE 'Log %: % | % min | %', rec.log_id, rec.item_name, rec.preparation_time, rec.prep_date;
        EXIT WHEN v_count >= 5;
    END LOOP;
    CLOSE v_cursor;
    RAISE NOTICE 'Displayed % preparation(s) for chef #1', v_count;
END; $$;
```

**הוכחת הרצה:**
```text
NOTICE:  === MAIN PROGRAM 2 : archive old logs + chef #1 preparations ===
NOTICE:  Archived (deleted) 0 preparation log(s) older than 2024-01-01
NOTICE:  Log 14504: Milk - Condensed 34 | 58 min | 2026-02-27
NOTICE:  Log 13411: Chinese Foods - Chicken Wing 23 | 38 min | 2026-02-26
NOTICE:  Log 17259: Sauce - Soya, Light 87 | 6 min | 2026-02-25
NOTICE:  Log 12822: Sardines 55 | 80 min | 2026-02-25
NOTICE:  Log 9220: Bread - Bagels, Plain 52 | 97 min | 2026-02-25
NOTICE:  Displayed 5 preparation(s) for chef #1
```

---

## 💾 גיבוי - שלב ד'

גיבוי מעודכן של בסיס הנתונים (כולל עמודת `times_prepared`, הפונקציות, הפרוצדורות והטריגרים) נשמר בפורמט `.tar` בשם `backup4`.

```bash
docker exec PostgreSQL_DB pg_dump -U MyUser -d DB5786David -F t -f /tmp/backup4.tar
```

![גיבוי 4](./Stage%20D/Screenshots/Backup4.png)

---

# 🖥 שלב ה': ממשק גרפי (GUI)

## 🎯 סקירת הממשק הגרפי

בשלב זה בנינו **אפליקציית שולחן עבודה** עם ממשק גרפי המתחברת לבסיס הנתונים המשולב (12 הטבלאות משלבים א'–ד'). האפליקציה מאפשרת גישה מלאה לכל הטבלאות עם **4 פעולות CRUD** (שליפה, הוספה, עדכון, מחיקה), וכן הרצת שאילתות משלב ב' ותוכניות (פונקציות/פרוצדורות) משלב ד' - הכל ישירות מתוך המסכים.

**עקרונות מרכזיים שמומשו:**
- **לא מוצגים מזהים (ID).** בכל הטבלאות, במקום ערך של מפתח זר מוצג הערך שאליו הוא מצביע (לדוגמה במקום `category_id = 68` מוצג `"Dips & Spreads 68"`).
- **עדכון (Update):** המשתמש בוחר רשומה (מספק את המפתח), המערכת **טוענת אוטומטית את שאר השדות**, ואז מעדכנים.
- **מפתחות זרים נבחרים מרשימות נפתחות של שמות** (combobox), כך שלא צריך להכיר מזהים.
- **תצוגה ידידותית** עם ערכת נושא כהה, כפתורים מעוצבים וסרגל ניווט.

## 🛠 כלים ודרך העבודה

| רכיב | טכנולוגיה |
|---|---|
| שפה | **Python 3.11** |
| ממשק גרפי | **customtkinter** (Tkinter מודרני - עיצוב כהה, פינות מעוגלות) |
| חיבור לבסיס הנתונים | **psycopg2** (אל `localhost:5432`) |

**ארכיטקטורה (תיקיית `Stage E/app`):**
- `main.py` - נקודת כניסה: מסך התחברות, לוח בקרה וניווט.
- `db.py` - שכבת גישה לבסיס הנתונים (חיבור, שליפה, DML, קריאה לפרוצדורות).
- `schema.py` - מטא-דאטה של 12 הטבלאות: עמודות, מפתחות, וכיצד להציג שמות במקום מפתחות זרים.
- `crud_view.py` - **מסך CRUD גנרי אחד** שעובד לכל 12 הטבלאות (כולל פתרון מפתחות זרים לשמות וזרימת עדכון).
- `programs_view.py` - מסך הרצת שאילתות שלב ב' ותוכניות שלב ד'.

דרך העבודה: הממשק מבוסס על **מטא-דאטה** - כל טבלה מתוארת פעם אחת ב-`schema.py`, ומסך ה-CRUD הגנרי בונה אוטומטית את הרשת, הטפסים ורשימות המפתחות הזרים. כך כל 12 הטבלאות נתמכות בקוד אחיד.

## 📖 הוראות הפעלה

1. ודאו ש-Docker רץ ובסיס הנתונים פעיל: `docker compose up -d`.
2. התקנת ספריות: `pip install -r requirements.txt` (מתוך `Stage E/app`).
3. הרצה: `python main.py`.
4. כניסה עם `MyUser` / `password` (אימות אמיתי מול PostgreSQL).

(הוראות מלאות בקובץ [`Stage E/HOW_TO_RUN.md`](./Stage%20E/HOW_TO_RUN.md).)

## 📸 צילומי מסך של האפליקציה

**מסך כניסה (Login):**

![מסך כניסה](./Stage%20E/Screenshots/login.png)

**לוח בקרה - ניווט לכל הטבלאות:**

![לוח בקרה](./Stage%20E/Screenshots/dashboard.png)

**מסך טבלה (CRUD) - שימו לב: אין מזהים, והקטגוריה מוצגת כשם:**

![מסך טבלה](./Stage%20E/Screenshots/menu_items.png)

**טופס עדכון - המשתמש בוחר רשומה והשדות נטענים אוטומטית:**

![טופס עדכון](./Stage%20E/Screenshots/edit_form.png)

**מסך Queries & Programs - שאילתות שלב ב' ותוכניות שלב ד':**

![שאילתות ותוכניות](./Stage%20E/Screenshots/programs.png)
