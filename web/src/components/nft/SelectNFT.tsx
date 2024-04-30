import { NFTInfo } from "@/types";
import classNames from "classnames";

import Image from "next/image";

import { blurImageURL, defaultNFT } from "@/config";
import { useState } from "react";

export default function SelectNFT(props: {
  nft: NFTInfo;
  selected: Boolean;
  onClick: (nft: NFTInfo) => void;
  onConfirm: (nft: NFTInfo) => void;
}) {
  const { nft, selected, onClick, onConfirm } = props;
  const [image, setImage] = useState(
    nft?.image === "" ? defaultNFT : props.nft.image
  );
  return (
    <div
      className={classNames(
        "card card-compact bg-base-100 shadow-xl hover:border cursor-pointer",
        selected && "border image-full"
      )}
      onClick={() => onClick(nft)}
    >
      <figure>
        <Image
          placeholder="blur"
          blurDataURL={blurImageURL}
          src={image}
          width={300}
          height={200}
          // // sizes="width:100%"
          unoptimized={true}
          alt=""
          onError={() => {
            setImage(defaultNFT);
          }}
        ></Image>
      </figure>
      <div className="card-body">
        <h2 className="card-title font-thin text-sm truncate w-full max-w-60">
          {nft.name}#{nft.tokenId}
        </h2>

        {selected && (
          <div className="card-actions justify-end">
            <button
              className="btn btn-primary btn-lg min-w-full"
              onClick={(e) => {
                e.stopPropagation();
                onConfirm(nft);
              }}
            >
              Confirm
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
