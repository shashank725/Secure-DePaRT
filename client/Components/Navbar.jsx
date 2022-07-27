import Image from "next/image";
import { useContext } from "react";
import { useMoralis } from "react-moralis";
import AUTH_CONTEXT from "../context/context";
import styles from "../styles/navbar.module.css";

export default function Navbar() {
  const { signIn ,signOut} = useContext(AUTH_CONTEXT);
  const {user}=useMoralis();
  return (
    <div className={`bg-black h-[80px] z-[100] `}>
      <div className={styles.headerContainer}>
        <div className={styles.headerLeft}>
          <div className={`${styles.secure} font-100`}>
            Secure<span>DePaRT</span>
          </div>
        </div>
        <div className="flex gap-8 items-center justify-center">
          <div>
            {!user ? (
              <button
                onClick={signIn}
                className="w-36 text-primary hover:bg-primary hover:text-white text-base border-2 h-10 bg-transparent  font-100 border-primary rounded"
              >
                Connect Wallet
              </button>
             ) : (
              <>
                <button
                  onClick={signOut}
                  className="w-36 text-primary hover:bg-primary hover:text-white text-base border-2 h-10 bg-transparent  font-100 border-primary rounded"
                >
                Log Out
                </button>
              </>
            )} 
          </div>

          <div className="flex items-center justify-center">
            <a href="/">
              <Image
                src={"/icons/git.svg"}
                width={28}
                height={28}
                layout="intrinsic"
                objectFit="contain"
              />
            </a>
          </div>
        </div>
      </div>
    </div>
  );
}
