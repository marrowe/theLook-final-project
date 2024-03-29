
# theLook Final Analysis

## The Task
This analysis has been prepared for theLook, a (fictitious) online boutique founded in January 2019 by the Google Looker team (as a synthetic dataset). Although theLook has seen strong sales and revenue since its founding, roughly doubling its revenue every year, the site has seen experienced consistently high return rates. Though never beloved among ecommerce retailers, returns have increasingly become a thorn in their side since the COVID-19 pandemic, attacking profit margins, increasing waste and emissions, and causing logistics headaches. But as ecommerce giant [Shopify](https://www.shopify.com/enterprise/ecommerce-returns) wrote, “Ecommerce returns can be a disease…but they don’t have to be the plague.” After all, the returns platform [Loop](https://www.loopreturns.com/blog/customers-repeat-puchase-when-they-refund/) found that customers who make returns are both more likely to make another purchase and more likely to do so sooner than those who kept their original order. Looking to understand the patterns underlying its returns and seek to minimize them, theLook asked me to take a look at its (synthetic) internal data on returns to understand what’s being returned, who’s returning it, and what impact it has on revenue and customer loyalty – and where theLook can go from there to improve its return rate and, if returns are an inevitability in the 2020s, ensuring they improve, rather than detract from, the customer experience.

This analysis was originally created for the Google Data Analytics Certificate capstone project in August 2023 and was updated and put online in January 2024.


## Data Used
TheLook offered me access to [their database](https://console.cloud.google.com/marketplace/product/bigquery-public-data/thelook-ecommerce), which is hosted on BigQuery Public Data. The data are split across seven tables comprising distribution_centers, events, inventory_items, order_items, orders, products, and users, which I then queried using SQL on BigQuery. 

I focused my analysis only on Complete and Returned orders, filtering out those that were cancelled or were still in processing and shipping. Due to the nature of the synthetic data, orders that are processing or shipping are never delivered, making them unhelpful for analysis. Cancelled orders, while potentially interesting, are beyond the scope of this analysis.)

I only looked at orders that were delivered or returned from the store’s founding on January 1, 2019, to on or before August 31, 2023.
Note that theLook’s data is synthetic and refreshes daily. The values I pulled will not match future data.


### Data Cleaning Notes
To narrow the scope of my analysis and avoid issues stemming from the synthetic data (which generates order statuses and does not update them), I focused only on orders whose order statuses were marked as Complete or Returned. I filtered out orders that were cancelled, in processing, or currently shipping. When product categories were analyzed, categories with fewer than 100 orders were removed (in this case, only Jumpsuits & Rompers), while duplicate categories (“Suits” and “Suits & Sport Coats,” “Socks” and “Socks & Hosiery,” and “Pants” and “Pants & Capris”) were combined. This left 45,426 distinct items purchased across 21 categories.

![Bar graph titled "Lifetime Purchases by Category, through August 2023"](https://64.media.tumblr.com/7011812e8d4047eece86b703efd766ea/tumblr_inline_s7gqfbqa5V1vy3o8a_500.png)

## The Analysis
### Background
Over its four-and-a-half years in business at the time of this analysis, theLook has grown from just two sales its first month (both returned!) to over 1,800 in August 2023. TheLook posted six straight months of growth and has seen month-to-month sales growth 75% of the time. They have sold over 31,000 individual items to over 27,000 distinct customers in 12 countries, while processing over 8,000 returns. In this time, they’ve reached nearly $2 million in lifetime completed sales, with a profit margin of 52%. On average, customers purchase just 1.4 items, and never more than 4, with an average item price of $59.62. A majority of customers (86%) have made just one purchase, though 30% of one-time customers ultimately returned their purchase.

### Changes Over Time
TheLook’s return rate has been remarkably consistent over time. Looking between August 2021 and August 2023, we see that it has hovered between 27% and 31% each month, with no identifiable holiday-related patterns. However, given that theLook’s sales have doubled in size every year, this also means that lost sales have increased, too: over the two-year period from August 2021 to August 2023, theLook grew from about $15,000 in lost sales to over $76,000. Total returns increased from 188 a month to 882 during that time. 
![Bar graph entitled "Monthly Sales at theLook, August 2021-August 2023"](https://64.media.tumblr.com/7b3627ba984ad45701e983acc726619b/tumblr_inline_s7gqsskQjh1vy3o8a_500.png)

### Top Rates of Return
Discussion on the top rates of return...
Twenty-eight percent of all orders from theLook are returned. As a fashion retailer, returns at theLook are slightly above national polling data showing that, as of March 2023, consumers return 26% of their clothing purchases. But across the 21 categories of merchandise sold, return rates hover between a low of 26% (Blazers & Jackets) and 30% (Dresses). 

| Category        | # returned | % orders returned | Revenue lost ($) |
|-----------------|------------|-------------------|------------------|
| Dresses         | 412        | 0.3041            | 16086.83         |
| Skirts          | 153        | 0.3036            | 2865.82          |
| Underwear       | 581        | 0.2954            | 7497.57          |
| Accessories     | 731        | 0.2911            | 13222.59         |
| Sleep & Lounge  | 808        | 0.2886            | 19710.52         |

Unfortunately, theLook does not collect reasons for customer return, making it difficult to gauge why these items in particular get returned. However, [Statista](https://www.statista.com/statistics/1300981/main-reasons-return-clothes-bought-online/) found that in 2021, items not fitting or not flattering the purchaser accounted for half of all returns. Given the composition of the most-returned items, it is possible that many returns are driven by these issues, especially given the importance of fit and/or comfort for the top categories. Additionally, items such underwear and some loungewear are not returnable once worn. TheLook may be experiencing heightened return fraud in these categories if customers are receiving refunds for non-refundable items.

Finally, while the national [rate of return for bags and accessories](https://www.shopify.com/enterprise/ecommerce-returns) is 19%, items in the Accessories category at theLook have a return rate of over 29% - in line with theLook's clothing returns but far above the national average. Given that theLook’s near-exclusive focus is on clothes alone, it may be that theLook is less experienced or resourced in sourcing and selling other items, like accessories.

### Lost Sales
Using the total sale prices of returned products, we find that theLook has lost over $750,000 in sales from returns since its founding through August 2023, accounting for more than 28% of its total sales and $391,000 in lost revenue. This is far above the average amount of merchandise returned as a percent of total online sales, which the National Retail Federation estimates to be just 16.5%. 

![Horizontal bar graph entitled "Share of Returns in Total Sales at theLook vs. U.S. eCommerce (estimated)"](https://64.media.tumblr.com/3d9cdceeffeff898293ae8beff425dd8/tumblr_inline_s7gqrvb80A1vy3o8a_500.png)

TheLook did not share shipping and restocking costs with me, but it is very likely that they pose a significant burden on revenue. It is estimated that [as much as 60%](https://www.ecommercetimes.com/story/retailers-wrestling-with-returns-mull-restocking-fees-176893.html) of returned goods are unsellable, leading to wasted merchandise totaling hundreds of thousands of dollars – without including the shipping costs or restocking fees. Ultimately, theLook has made one million dollars in profit over its lifetime, and it stands to make nearly $400,000 more if it is able to resell all returned merchandise (less shipping and restocking costs) – but it also stands to lose more than $200,000 on returns should 60% be unsellable.

![Bar graph entitled "Lifetime Profit and Potential Losses at theLook"](https://64.media.tumblr.com/6054e726e216fc6d0726a23bc7a38ce8/tumblr_inline_s7gqrlixog1vy3o8a_500.png)

## Recommendations and Additional Deliverables
List of recommendations...
- First and foremost, theLook needs to collect data before it can do anything about its returns. Without user reviews, reasons for returns, shipping and warehousing expenses, or even information on what happens to returned items, it’s impossible to know the full impact of returns on theLook’s bottom line.
- It is currently unclear what variables impact a customer’s decision to return an item. A required one-question survey for customers returning items that asks why they are doing so would be very helpful for providing greater insight into theLook’s returns.
  - Though it is currently impossible to know why certain items are being returned more than others, given the most common reasons for return, theLook will want to take care that images of the clothing in these categories are high-resolution clearly lit, taken from multiple angles, and represent a variety of sizes and body types, to ensure that purchasers have the fullest sense of what they are buying. The sizing charts should be clear and easily accessible, and promoted to shoppers to increase the chance of them checking measurements before purchasing. 
- Unusually for any ecommerce platform, the longitudinal data revealed that the holiday season (December-January) does not show an increase in returns from other months, nor does it show an increase in sales. This suggests that consumers are not turning to theLook for holiday shopping at all, leading to massive potential losses in seasonal revenue. More needs to be done to market the website as a destination for holiday shopping. 
- Although theLook did not share their return policy with me, it is possible that a longer return window than what is currently offered could be beneficial. While 100% of returned orders from theLook were returned within three days of purchase, research has shown that longer windows lead to lower return rates.
- The Accessories category sports a return rate high above the national average. More attention needs to be paid to the Accessories category if non-clothing items are to satisfy customers. Otherwise, theLook may be wise to cut accessories entirely and focus on their primary business in clothing alone.
- Despite a majority global customer base, theLook only has distribution centers in the continental United States. Additionally, theLook did not track shipping costs and warehouse expenditures in the data shared with me, making it difficult to determine the true cost of handling returns. Though beyond the scope of this analysis, additional work should be done on understanding international market trends, how returns vary by region, and how the cost of a global distribution network could be outweighed by the gains.
