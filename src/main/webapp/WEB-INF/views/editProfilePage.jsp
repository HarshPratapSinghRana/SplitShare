<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Edit Profile</title>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <style>
    .profile-photo {
      width: 150px;
      height: 150px;
      object-fit: cover;
      border-radius: 50%;
    }
    .tab-content {
      padding-top: 20px;
    }
  </style>
</head>
<body>
  <div class="container mt-5">
    <h1>Edit Profile</h1>
    <ul class="nav nav-tabs" id="editProfileTab" role="tablist">
      <li class="nav-item" role="presentation">
        <button class="nav-link active" id="profile-info-tab" data-bs-toggle="tab" data-bs-target="#profile-info" type = "button" role="tab" aria-controls="profile-info" aria-selected="true">
          Profile Info
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link" id="account-details-tab" data-bs-toggle="tab" data-bs-target="#account-details" type = "button" role="tab" aria-controls="account-details" aria-selected="false">
          Account Details
        </button>
      </li>
    </ul>

    <div class="tab-content" id="editProfileTabContent">

      <div class="tab-pane fade show active" id="profile-info" role="tabpanel" aria-labelledby="profile-info-tab">
        <form class = "submit-form" id="profileForm" action="profile/${account.id}/updateProfile" method="post" enctype="multipart/form-data">

          <div class="form-group">
            <label>Photo</label>
            <div class="mb-3">
              <c:choose>
                <c:when test = "${not empty account.profile.base64photo}">
                    <c:set var = "imgSrc" value = "data:image/jpeg;base64,${account.profile.base64photo}"/>
                </c:when>
                <c:otherwise>
                    <c:set var="imgSrc" value = "../../images/default-profile-photo.png"/>
                </c:otherwise>
              </c:choose>
              <img id="currentPhoto"
              src="${imgSrc}"
              alt="Current Photo"
              class="profile-photo">
            </div>
            <input type="file" class="form-control-file" id="photo" name="photo">
          </div>

          <div class="form-group">
            <label for="name">Name</label>
            <input
              type="text"
              class="form-control"
              id="name"
              name="profile.name"
              value="${account.profile.name}"
              pattern="[A-Za-z ]+"
              title = "Name can only contain letters and space"
              placeholder="Enter your name">
          </div>

          <div class="form-row">
            <div class="form-group col-md-4">
              <label for="city">City</label>
              <input
                type="text"
                class="form-control"
                id="city"
                name="profile.address.city"
                value="${account.profile.address.city}"
                pattern="[A-Za-z ]+"
                title = "City can only contain letters and space"
                placeholder="City">
            </div>

            <div class="form-group col-md-4">
              <label for="state">State</label>
              <input
                type="text"
                class="form-control"
                id="state"
                name="profile.address.state"
                value="${account.profile.address.state}"
                pattern="[A-Za-z ]+"
                title = "State can only contain letters and space"
                placeholder="State">
            </div>

            <div class="form-group col-md-4">
              <label for="country">Country</label>
              <input
                type="text"
                class="form-control"
                id="country"
                name="profile.address.country"
                value="${account.profile.address.country}"
                pattern="[A-Za-z ]+"
                title = "Country can only contain letters and space"
                placeholder="Country">
            </div>
          </div>

          <div class="form-group">
            <label for="about">About</label>
            <textarea class="form-control" id="about" name="profile.about" rows="3" placeholder="Tell us about yourself">${account.profile.about}</textarea>
          </div>

          <button type="submit" class="btn btn-primary">Save Profile</button>
        </form>
      </div>

      <div class="tab-pane fade" id="account-details" role="tabpanel" aria-labelledby="account-details-tab">
        <form class = "submit-form" id="accountForm" action="profile/${account.id}/updateAccount" method="post">
          <div class="form-group">
            <label for="email">Email</label>
            <input
              type="email"
              class="form-control"
              id="email"
              name="email"
              value="${account.email}"
              placeholder="Enter your email"
              required>
          </div>

          <div class="form-group">
            <label for="username">Username/ID</label>
            <input
              type="text"
              class="form-control"
              id="username"
              name="id"
              value="${account.id}"
              readonly>
          </div>

          <div class="form-group">
            <label for="currentPassword">Current Password</label>
            <input
              type="password"
              class="form-control"
              id="currentPassword"
              name="currentPassword"
              placeholder="Enter current password to edit">
          </div>
          <div id="passwordError" class="alert alert-danger" role="alert" style="display: none;">
            Current password is incorrect!
          </div>

          <!-- New Password Fields; hidden until current password is verified -->
          <div id="newPasswordFields" style="display:none;">
            <div class="form-group">
              <label for="newPassword">New Password</label>
              <input
                type="password"
                class="form-control"
                id="newPassword"
                name="newPassword"
                minlength = "8"
                title = "Password should be atleast 8 characters long"
                placeholder="Enter new password">
            </div>
            <div class="form-group">
              <label for="confirmPassword">Confirm New Password</label>
              <input
                type="password"
                class="form-control"
                id="confirmPassword"
                name="confirmPassword"
                placeholder="Confirm new password">
                <div id = "passwordErrorMessage" class = "text-danger" style = "display:none;"></div>
            </div>
          </div>

          <div class="form-group">
            <label for="mobile">Mobile (10 digits)</label>
            <input
              type="text"
              class="form-control"
              id="mobile"
              name="mobile"
              value="${account.mobile}"
              pattern = "\d{10}"
              title = "Mobile number must be exactly 10 digits"
              placeholder="Enter your mobile number"
              required>
          </div>

          <button type="button" id="verifyPasswordBtn" class="btn btn-secondary">Verify Current Password</button>
          <button type="submit" class="btn btn-primary" id="accountSubmitBtn" style="display:none;" disabled>Save Account Changes</button>
        </form>
      </div>
    </div>
  </div>
  <div id="saveAlert" class="alert alert-success" style="display:none;">
    Details updated!
  </div>
  <div id="saveAlertError" class="alert alert-failure" style="display:none;">
      Error updating Details!
  </div>

  <script>
    $(document).ready(function(){

      $("#verifyPasswordBtn").click(function(){
        var currentPassword = $("#currentPassword").val();
        var storedPassword = "${account.password}";

        if(currentPassword === storedPassword){
          $("#newPasswordFields").slideDown();
          $("#accountSubmitBtn").show();
          $(this).prop("disabled", true);
          $("#currentPassword").prop("readonly", true);
        } else {
          $("#passwordError")
                            .show()
                            .delay(2000)
                            .fadeOut();
        }
      });


      $("#photo").change(function(){
        var file = this.files[0];
        if(file){
          var reader = new FileReader();
          reader.onload = function(e){
            $("#currentPhoto").attr("src", e.target.result);
            $("#base64photo").val(e.target.result);
            $("#photobytes").val(e.target.result);
          }
          reader.readAsDataURL(file);
        }
      });

      $(".submit-form").on("submit", function(e){
        e.preventDefault();
        var formData = new FormData(this);

        $.ajax({
            url: $(this).attr("action"),
            type: $(this).attr("method"),
            data: formData,
            processData: false,
            success: function(response){
                $("#saveAlert").fadeIn().delay(2000).fadeOut();
            },
            error: function(xhr, status, error){
                $("#saveAlertError").fadeIn().delay(2000).fadeOut();
            }
        });
      });

      function validatePasswords(){
        var newPassword = $("#newPassword").val();
        var confirmPassword = $("#confirmPassword").val();
        var errorMessage = "";
        if(newPassword.length < 8){
            errorMessage = "Password must be atleast 8 characters long.";
        }else if(newPassword !== confirmPassword){
            errorMessage = "Passwords do not match.";
        }
        if(errorMessage){
            $("#passwordErrorMessage").text(errorMessage).show();
            $("#accountSubmitBtn").prop("disabled", true);
        }else{
            $("#passwordErrorMessage").hide();
            $("#accountSubmitBtn").prop("disabled", false);
        }
      }
      $("#newPassword, #confirmPassword").on("input", validatePasswords);

    });
  </script>
</body>
</html>
