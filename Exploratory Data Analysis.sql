SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2 ;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 ;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC ;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC ;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC ;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2 ;

SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 1 DESC ;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC ;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC ;

SELECT company, SUM(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 1 DESC ;

-- ROLLING SUM --
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date` , 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC ;

WITH rolling_total AS (
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date` , 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC )
SELECT `MONTH`,  total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS Rolling_Total
FROM rolling_total;

SELECT country, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country, YEAR(`date`)
ORDER BY 3 DESC ;

WITH company_year AS (
SELECT company, YEAR(`date`) AS years, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC)
SELECT * 
FROM company_year ;
-- ORR
WITH company_year (company, years, total_laid_off)
AS (
SELECT company, YEAR(`date`) AS years, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC)
SELECT * , DENSE_RANK() OVER(PARTITION BY years order by total_laid_off DESC) AS ranking
FROM company_year
ORDER BY ranking ;

WITH company_year (company, years, total_laid_off)
AS (
SELECT company, YEAR(`date`) AS years, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC),
company_year_rank AS (
SELECT * , DENSE_RANK() OVER(PARTITION BY years order by total_laid_off DESC) AS ranking
FROM company_year)
SELECT *
FROM company_year_rank
WHERE ranking <= 5;
