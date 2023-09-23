<script>
  import { FirebaseApp, SignedIn, SignedOut } from "sveltefire";
  import { signInAnonymously } from "firebase/auth";
  import { auth, firestore } from '../firebase';
</script>

<FirebaseApp {auth} {firestore}>
  <SignedIn let:user let:signOut>
    <p>Hello {user.uid}</p>
    <button on:click={signOut}>Sign Out</button>
  </SignedIn>

  <SignedOut let:auth>
    <button on:click={() => signInAnonymously(auth)}>Sign In</button>
  </SignedOut>

  <div class="container">
    <slot />
  </div>
</FirebaseApp>
