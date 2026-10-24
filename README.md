# EcoTransit — Green Mobility

**Move smarter. Share better. Travel greener.**

EcoTransit is a campus mobility web app that helps students find low-emission transport, share rides with others on the same route, and see how much CO₂ their choices save. It can also be installed on a phone like an app.

🔗 **Live app:** https://ecotransit-zax7.onrender.com (free hosting: the first load can take up to a minute)

---

## Why I built it

Transport is a major source of fuel use, congestion and carbon emissions in Indian cities, and campus trips are a big part of a student's day. EcoTransit makes the greener option the easy one: electric vehicles, bicycles and shared rides are easy to find and book, and every trip turns into a measurable environmental contribution.

## Features

- **Find a ride:** browse available vehicle slots by route, time and fuel type (electric, bicycle and other low-emission options).
- **Book in one click:** seat availability updates live, so a full slot can't be overbooked.
- **Share your ride:** start a shared ride and give classmates a join code, so several students travel in one vehicle.
- **Schedule ahead:** plan recurring rides and save favourite routes.
- **Track your impact:** see your rides, distance travelled and estimated CO₂ saved, broken down by day, month and year.
- **Campus dashboard and leaderboard:** campus-wide totals, a monthly emission summary, and a ranking of students by CO₂ saved.
- **Installable app (PWA):** add it to a phone's home screen; it opens full-screen with its own icon and shows a friendly page when offline.

## Built with

| Layer | Technology |
|---|---|
| Frontend | JSP, HTML, CSS (responsive, mobile-first) |
| Backend | Java (JSP on Apache Tomcat 9) |
| Database | MySQL (JDBC with prepared statements) |
| App layer | Web App Manifest + Service Worker (PWA) |
| Hosting | Docker on Render, MySQL on Aiven |

## How CO₂ savings are calculated

Each vehicle slot stores its route distance and an emission factor (`co2_per_km`). When a student books a ride, the app compares the trip's emissions with a conventional baseline of 0.12 kg CO₂ per km and records the difference as CO₂ saved. Those savings add up into each student's total and feed the impact charts and the leaderboard.

## Run it locally

1. Install [XAMPP](https://www.apachefriends.org/) (includes Tomcat and MySQL), and start **MySQL** and **Tomcat**.
2. In phpMyAdmin, create a database called `green_mobility` and import the SQL file from the `database` folder.
3. Copy this project into `C:\xampp\tomcat\webapps\EcoTransit`.
4. Open `http://localhost:8080/EcoTransit/`.

If your MySQL `root` user has a password, set it in an environment variable called `DB_PASSWORD` before starting Tomcat.

### Environment variables

| Name | Purpose | Default |
|---|---|---|
| `DB_URL` | JDBC connection URL | `jdbc:mysql://localhost:3306/green_mobility` |
| `DB_USER` | Database user | `root` |
| `DB_PASSWORD` | Database password | _(empty)_ |

## What I learned

- Designing a relational schema for bookings, shared rides and participants, and keeping seat counts consistent when rides are booked or cancelled.
- Using prepared statements to keep database queries safe from SQL injection.
- Turning a server-rendered site into an installable Progressive Web App.
- Deploying a Java web app with Docker, and keeping secrets out of the code with environment variables.

## Author

**Rama Sudeshna** — B.Tech Computer Science and Engineering, Woxsen University, Hyderabad
