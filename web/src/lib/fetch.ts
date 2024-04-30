import useSWR from "swr";
import { useAccount } from "wagmi";

const fetcher = (
  input: string | URL | globalThis.Request,
  init?: RequestInit
) => fetch(input, init).then((res) => res.json());

/**
 * 
 * @returns 
 */
export function useUserNFTs() {
  const { address, chainId, isConnected } = useAccount();
  const { data, error, isLoading } = useSWR(
    isConnected ? `/api/user/nft?chainId=${chainId!}&wallet=${address!}` : null,
    fetcher
  );
  if (error || !data) {
    return {
      data,
      error,
      isLoading,
    };
  } else if (data.code !== 0) {
    return {
      data: [],
      error: data.message,
      isLoading,
    };
  } else {
    return {
      data: data.data,
      error,
      isLoading,
    };
  }
}

export function useUserListing() {
  const { address, chainId, isConnected } = useAccount();
  const { data, error, isLoading } = useSWR(
    isConnected
      ? `/api/user/listing?chainId=${chainId!}&wallet=${address!}`
      : null,
    fetcher
  );
  if (error || !data) {
    return {
      data,
      error,
      isLoading,
    };
  } else if (data.code !== 0) {
    return {
      data: [],
      error: data.message,
      isLoading,
    };
  } else {
    return {
      data: data.data,
      error,
      isLoading,
    };
  }
}
