import consumer from "./consumer"


//   // consumer.subscriptions.create({channel: 'NotificationsChannel', id: 3}, {
//   //   connected() {
//   //     console.log("NotificationsChannel connected");
//   //   },

//   //   disconnected() {
//   //     // Called when the subscription has been terminated by the server
//   //   },

//   //   received(data) {
//   //     console.log(data);
//   //     $('notification-count')
//   //   }
//   // });


// document.addEventListener('DOMContentLoaded', () => {
//   // const notificationList = document.getElementById('notification-list');
//   const notificationCountElement = document.getElementById('notification-count');
//   // const resetCountButton = document.getElementById('reset-count-button');

//   consumer.subscriptions.create({channel: 'NotificationsChannel', id: 3}, {
//     connected() {
//       console.log("NotificationsChannel connected");
//     },

//     disconnected() {
//       // Called when the subscription has been terminated by the server
//     },

//     received(data) {
//       // const newNotificationItem = document.createElement('a');
//       // newNotificationItem.classList.add('dropdown-item');
//       // newNotificationItem.href = '#';
//       // newNotificationItem.textContent = data.message;

//       // notificationList.appendChild(newNotificationItem);

//       const currentCount = parseInt(notificationCountElement.innerText);
//       console.log(currentCount);
//       const newCount = currentCount + 1;
//       notificationCountElement.innerText = newCount.toString();
//     }
//   });

//   // resetCountButton.addEventListener('click', () => {
//   //   resetNotificationCount();
//   // });

//   // function resetNotificationCount() {
//   //   notificationCountElement.innerText = '0';

//   //   // Update the attribute directly to reflect the reset value in the view
//   //   notificationCountElement.setAttribute('data-count', '0');
//   // }
// });
