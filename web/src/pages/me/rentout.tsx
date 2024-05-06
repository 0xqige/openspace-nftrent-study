import _ from "lodash";
import { useState, FormEvent, useRef } from "react";
import classNames from "classnames";
import { toast } from "react-toastify";

import NFTCard from "@/components/nft/NFTCard";
import Link from "next/link";

import SelectNFT from "@/components/nft/SelectNFT";
import { NFTInfo } from "@/types";
import { useUserNFTs } from "@/lib/fetch";

export default function Rentout() {
  const nftResp = useUserNFTs();

  const [selectedNft, setSelectedNft] = useState<NFTInfo | null>(null);
  const [step, setStep] = useState(1);

  const [rentalDuration, setRentalDuration] = useState(7);
  const [dailyRent, setDailyRent] = useState(0.1);
  const [collateral, setCollateral] = useState(0.1);
  const [listLifetime, setListLifetime] = useState(7);

  const handleSelectNft = (nft: NFTInfo) => {
    console.log("when select");
    if (selectedNft?.id === nft.id) {
      setSelectedNft(null);
    } else {
      setSelectedNft(nft);
    }
  };

  const handleConfirm = (nft: NFTInfo) => {
    console.log("when confirm");
    setSelectedNft(nft);
    setStep(2);
  };

  // submit loading
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const maxRentalDurationRef = useRef<HTMLInputElement>(null);
  const dailyRentRef = useRef<HTMLInputElement>(null);
  const collateralRef = useRef<HTMLInputElement>(null);
  const listLifetimeRef = useRef<HTMLInputElement>(null);

  // submit listing order
  const handleSubmitListing = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (!selectedNft) return;

    setIsLoading(true);

    try {
      const order = {
        nftCA: selectedNft.ca,
        tokenId: selectedNft.tokenId,
        dailyRent: dailyRentRef.current?.value,
        maxRentalDuration: maxRentalDurationRef.current?.value,
        minCollateral: collateralRef.current?.value,
        listEndTime: listLifetimeRef.current?.value,
      };
      console.log(order);
      const response = await fetch("/api/listing", {
        method: "POST",
        body: JSON.stringify(order),
      });

      if (!response.ok) {
        throw new Error(
          "Failed to submit the data. Please try again." + response.statusText
        );
      }

      // Handle response if necessary
      const data = await response.json();
      if (data.error) {
        throw new Error(data.error);
      } else if (data.code !== 0) {
        throw new Error(data.message);
      }
      setStep(3);
    } catch (error: any) {
      // Capture the error message to display to the user
      toast.error(error.message);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="grid gap-y-6">
      <h2 className="min-w-full text-center font-bold text-pink-600">
        Rent out NFT , Earn ETH
      </h2>

      <ul className="steps min-w-full cursor-pointer">
        <li className="step step-primary" onClick={() => setStep(1)}>
          Select NFT
        </li>
        <li
          className={classNames("step", step >= 2 && "step-primary")}
          onClick={() => selectedNft && setStep(2)}
        >
          Sign List Order
        </li>
        <li className={classNames("step", step >= 3 && "step-primary")}>
          Earn ETH
        </li>
      </ul>

      {nftResp.isLoading && (
        <>
          <div className="flex flex-col gap-4 w-52">
            <div className="skeleton h-32 w-full"></div>
            <div className="skeleton h-4 w-28"></div>
            <div className="skeleton h-4 w-full"></div>
            <div className="skeleton h-4 w-full"></div>
          </div>
        </>
      )}
      {step === 1 && nftResp.data && (
        <div className="grid md:grid-cols-4 sm:grid-cols-3 w-full gap-2.5">
          {nftResp.data.map((nft: any) => (
            <SelectNFT
              key={nft.id}
              nft={nft}
              selected={nft.id === selectedNft?.id}
              onClick={handleSelectNft}
              onConfirm={handleConfirm}
            ></SelectNFT>
          ))}
        </div>
      )}
      {step === 2 && selectedNft && (
        <>
          <div className="flex w-full justify-center gap-12">
            <NFTCard nft={selectedNft} />
            <div className="grid">
              <form onSubmit={(e) => handleSubmitListing(e)}>
                <label className="form-control  w-full max-w-xs">
                  <div className="label">
                    <span className="label-text">Max Rental Duration</span>
                    <span className="label-text-alt"></span>
                  </div>
                  <label className="range">
                    <input
                      required
                      type="range"
                      min="0.5"
                      max="365"
                      step="0.5"
                      value={rentalDuration}
                      ref={maxRentalDurationRef}
                      onChange={(e) =>
                        setRentalDuration(Number(e.target.value))
                      }
                      className="range range-xs range-primary"
                    />
                  </label>
                  <div className="label">
                    <span className="label-text"></span>
                    <label className="label-text-alt">
                      {rentalDuration} days
                    </label>
                  </div>
                </label>
                <label className="form-control  w-full max-w-xs">
                  <div className="label">
                    <span className="label-text">Daily Rent</span>
                    <span className="label-text-alt"></span>
                  </div>
                  <label className="input input-bordered flex items-center gap-2">
                    <input
                      type="number"
                      ref={dailyRentRef}
                      className="grow"
                      name="dailyRent"
                      min={0.0000001}
                      required
                    />
                    <span className="">ETH</span>
                  </label>
                  <div className="label">
                    <span className="label-text"></span>
                    <span className="label-text-alt text-base-500">
                      Est. Max earn:0.2 ETH
                    </span>
                  </div>
                </label>
                <label className="form-control  w-full max-w-xs">
                  <div className="label">
                    <span className="label-text">Min Collateral</span>
                    <span className="label-text-alt"></span>
                  </div>
                  <label className="input input-bordered flex items-center gap-2">
                    <input
                      type="number"
                      ref={collateralRef}
                      className="grow"
                      placeholder=""
                      min={0.0000001}
                      required
                    />
                    <span className="">ETH</span>
                  </label>
                  <div className="label">
                    <span className="label-text"></span>
                    <span className="label-text-alt text-base-500"></span>
                  </div>
                </label>
                <label className="form-control  w-full max-w-xs">
                  <div className="label">
                    <span className="label-text">Order List Expiry</span>
                    <span className="label-text-alt"></span>
                  </div>
                  <label className="range">
                    <input
                      required
                      type="range"
                      ref={listLifetimeRef}
                      min="0.5"
                      max="180"
                      step="0.5"
                      value={listLifetime}
                      onChange={(e) => setListLifetime(Number(e.target.value))}
                      className="range range-xs range-primary"
                    />
                  </label>
                  <div className="label">
                    <span className="label-text"></span>
                    <label className="label-text-alt">
                      {listLifetime} days
                    </label>
                  </div>
                </label>

                <label className="form-control  w-full max-w-xs">
                  <button
                    type="submit"
                    className="btn btn-primary"
                    disabled={isLoading}
                  >
                    {isLoading && (
                      <span className="loading loading-ring loading-sm"></span>
                    )}
                    List Now
                  </button>
                </label>
              </form>
            </div>
          </div>
          <div className="flex  w-full justify-center gap-12">
            <p className="max-w-2xl text-base-200 hover:text-base-content">
              During the listing period, there is no need to lock your NFT. The
              transfer of NFT only occurs upon lending, allowing you to start
              earning rental income. At the end of the term, if the tenant fails
              to return the NFT, you have the option to liquidate (seize
              collateral) and terminate the lease.
            </p>
          </div>
        </>
      )}

      {step === 3 && selectedNft && (
        <>
          <div className="flex w-full justify-center gap-12  items-center">
            <NFTCard nft={selectedNft} />
            <div>
              <p className="text-primary mb-5">
                Congratulations, your NFT has been listed! After being leased,
                you can collect rent every day!
              </p>
              <div className="w-full justify-end flex">
                <Link href="/me" className="btn-link">
                  See My List
                </Link>
              </div>
            </div>
          </div>
        </>
      )}
    </div>
  );
}
