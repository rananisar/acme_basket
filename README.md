# Acme Widget Co – Basket Pricing System

A simple Ruby proof of concept for **Acme Widget Co**’s sales system.  
This project demonstrates a basket pricing engine that:

- Applies delivery charge rules
- Applies product-specific offers (e.g., buy one get one half price)
- Calculates the total cost for a basket of products

All code is implemented in `main.rb`.

---

## Features

- **Product Catalogue**
  - Products have `code`, `name`, and `price`
- **Delivery Rules**
  - Threshold-based delivery charges:
    - Orders under $50 → $4.95
    - Orders $50–$89.99 → $2.95
    - Orders $90 or more → free
- **Offers**
  - Buy one red widget, get the second half price
  - Implemented via a strategy pattern for easy extension
- **Basket**
  - Add products by code
  - Calculate total including discounts and delivery

---

## Assumptions

- Product catalogue is injected into the `Basket` at initialization
- Discounts are applied **before** delivery charges
- Offers can be extended by creating new subclasses of `Offer`
- Invalid product codes will raise an error

---

## Project Structure

acme_basket/
├── main.rb # Main implementation file
└── README.md # Project documentation


No external gems or dependencies are required.  
Simply have Ruby installed to run the project.

---

## Project Setup & Running the Project

Clone the repository and move into the project directory:

```bash
git clone https://github.com/rananisar/acme_basket.git
cd acme_basket
Run the program using Ruby:

ruby main.rb
The script will demonstrate example baskets and print their totals.