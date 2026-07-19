cat << 'EOF' > giantbirth.py
import time
import re
import os
import sys
import pyautogui
import pytesseract
import keyboard
from PIL import Image, ImageOps

# --- VARIABILELE TALE ---
ZONA_NIVEL = (70, 160, 55, 40)
BUTON_MENIU_REBIRTH = (55, 430)
BUTON_REBIRTH = (1205, 785)
BUTON_CONFIRM_REBIRTH = (920, 615)
BUTON_MASS_UPGRADE = (900, 810)
TAB_REBIRTH = (940, 190)
ZONA_LEVEL_UP = (525, 135)

# Variabilele tale pentru Inventory și Sabie
BUTON_MENIU_INVENTORY = (50, 255)
BUTON_MAX_UPGRADE_SWORD = (1515, 805)
BUTON_CONFIRM_SWORD = (895, 605)

pyautogui.PAUSE = 0.0
pyautogui.FAILSAFE = True

def verifica_urgenta():
    if keyboard.is_pressed('c'):
        print("\n[!] Tasta 'C' a fost apăsată! Oprire de urgență instantanee.")
        sys.exit(0)

def spam_click_rapid(coordonate):
    verifica_urgenta()
    x, y = coordonate
    pyautogui.platformModule._click(x, y, 'left')
    time.sleep(0.05)

def click_apasat_meniu(coordonate):
    verifica_urgenta()
    x, y = coordonate
    pyautogui.moveTo(x, y)
    time.sleep(0.02)
    pyautogui.mouseDown(button='left')
    time.sleep(0.08)  # Apăsare rapidă standard pentru meniuri
    pyautogui.mouseUp(button='left')
    time.sleep(0.03)

def citeste_nivelul_real():
    try:
        os.system("scrot -u -o -a 70,160,55,40 /dev/shm/clip.png >/dev/null 2>&1")
        if os.path.exists("/dev/shm/clip.png"):
            img = Image.open("/dev/shm/clip.png").convert('L')
            img = img.resize((img.width * 3, img.height * 3))
            img = ImageOps.autocontrast(img)
            
            text = pytesseract.image_to_string(img, config='--psm 7 -c tessedit_char_whitelist=0123456789').strip()
            numere = re.findall(r'\d+', text)
            if numere:
                return int("".join(numere))
    except Exception:
        return 0
    return 0

def secventa_rebirth_si_upgrade():
    print("\n[+] Nivelul 100+! Pornesc execuția optimizată...")
    
    # 1. Procedura Rebirth
    click_apasat_meniu(BUTON_MENIU_REBIRTH)
    click_apasat_meniu(BUTON_REBIRTH)
    click_apasat_meniu(BUTON_CONFIRM_REBIRTH)
    
    # Pauză minimă ajustată pentru deschiderea automată la Skills (0.4s)
    for _ in range(4):
        time.sleep(0.1)
        verifica_urgenta()
        
    # 2. Mass Upgrade Skills
    click_apasat_meniu(BUTON_MASS_UPGRADE)
    click_apasat_meniu(TAB_REBIRTH)
    
    # 3. Upgrade Sabie în Inventory
    click_apasat_meniu(BUTON_MENIU_INVENTORY)
    time.sleep(0.12) # Timp minim fizic de deschidere a paginii de Inventory
    
    click_apasat_meniu(BUTON_MAX_UPGRADE_SWORD)
    click_apasat_meniu(BUTON_CONFIRM_SWORD)
    
    # Închidem meniul și eliberăm mouse-ul instant
    click_apasat_meniu(BUTON_MENIU_INVENTORY)
    
    print("[*] Upgrade-uri finalizate. Revin rapid la atac...")
    # PAUZĂ REDUSĂ MASIV: Doar 0.3 secunde înainte de a reîncepe spam-ul de click-uri
    for _ in range(3):
        time.sleep(0.1)
        verifica_urgenta()

# --- LOOP PRINCIPAL ---
print("[*] Pornire în 5 secunde. Pune jocul pe ecran!")
print("[!] APASĂ TASTA 'C' PENTRU OPRIRE INSTANTANEE.")
time.sleep(5)

contor_verificare = 0
nivel_memorie = 1

while True:
    verifica_urgenta()
    
    if contor_verificare >= 10:
        nivel_memorie = citeste_nivelul_real()
        contor_verificare = 0
        
        if nivel_memorie >= 100:
            secventa_rebirth_si_upgrade()
            nivel_memorie = 1
            continue
        else:
            print(f"[*] Nivel actual: {nivel_memorie} (sub 100). Atac rapid...")
            
    spam_click_rapid(ZONA_LEVEL_UP)
    contor_verificare += 1
EOF
