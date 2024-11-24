from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from bs4 import BeautifulSoup
import pandas as pd

# URL of the website to scrape
url = "https://www.islambook.com/azkar/1/أذكار-الصباح"

# Set up Selenium WebDriver
chrome_options = Options()
chrome_options.add_argument("--headless")  # Ensure the browser runs in headless mode
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument("--disable-dev-shm-usage")

# Provide the path to your chromedriver executable
webdriver_service = Service('path/to/chromedriver')

# Create a WebDriver instance
driver = webdriver.Chrome(service=webdriver_service, options=chrome_options)

# Open the URL
driver.get(url)

# Give the page some time to load
driver.implicitly_wait(10)

# Parse the content with BeautifulSoup
soup = BeautifulSoup(driver.page_source, 'html.parser')

# Close the WebDriver
driver.quit()

# Find all azkar entries
azkar_entries = soup.find_all('div', class_='zekr')

# Extract the data
azkar_data = []
for entry in azkar_entries:
    zekr_text = entry.find('div', class_='zekr_text').get_text(strip=True)
    zekr_reference = entry.find('div', class_='zekr_source').get_text(strip=True) if entry.find('div', 'zekr_source') else ''
    azkar_data.append({
        'Text': zekr_text,
        'Reference': zekr_reference
    })

# Create a DataFrame
df_azkar = pd.DataFrame(azkar_data)

# Save the DataFrame to a CSV file
df_azkar.to_csv('morning_azkar.csv', index=False, encoding='utf-8-sig')

print("Data successfully scraped and saved to 'morning_azkar.csv'")
