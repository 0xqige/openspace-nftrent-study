import Image from "next/image";

import { blurImageURL, defaultNFT } from "@/config";
import { useState } from "react";
import { NFTInfo } from "@/types";
export default function NFTCard(props: { nft: NFTInfo }) {
  const { nft } = props;
  console.log("nfts:", nft);
  const [image, setImage] = useState(
    props?.nft?.image === "" ? defaultNFT : props.nft.image
  );
  return (
    <div className="card card-compact glass">
      <figure>
        <Image
          src={image}
          placeholder="blur"
          blurDataURL={blurImageURL}
          width={300}
          height={200}
          unoptimized={true}
          alt=""
          onError={() => {
            setImage(defaultNFT);
          }}
        ></Image>
      </figure>
      <div className="card-body">
        <h2 className="card-title text-sm">{props.nft.name}</h2>
      </div>
    </div>
  );
}
