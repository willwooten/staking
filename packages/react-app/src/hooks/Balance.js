import { useState } from "react";
import usePoller from "./Poller";

export default function useBalance(provider, address, pollTime) {
const [balance, setBalance] = useState();
const pollBalance = async () => {
  if (address && provider) {
    const newBalance = await provider.getBalance(address);
    if (newBalance !== balance) {
      // console.log("NEW BALANCE:",newBalance,"Current balance",balance)
      setBalance(newBalance);
    }
  }
};
usePoller(pollBalance, pollTime || 37777, address && provider );

return balance;
}
