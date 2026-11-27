# App Store positioning and screenshot research

Researched November 27, 2026. This is an evidence-informed launch direction, not a measured conversion winner. Public ratings establish a useful comparison set; they do not reveal downloads, revenue, or screenshot conversion rates.

## Comparable Mac utilities

| Reference | Public evidence | Applied lesson |
| --- | --- | --- |
| [Magnet](https://apps.apple.com/us/app/magnet/id441258766?mt=12&platform=mac&see-all=reviews) | U.S. reviews page displayed 4.9/5 from 168K ratings and an Editors’ Choice designation when researched. | Demonstrate a concrete workspace improvement. Name the outcome before explaining controls. |
| [Amphetamine](https://apps.apple.com/us/app/amphetamine/id937984704?mt=12&platform=mac&see-all=reviews) | U.S. reviews page displayed 4.8/5 from 3.2K ratings. The [listing](https://apps.apple.com/us/app/amphetamine/id937984704) is a free Utilities app. | Put the menu bar interaction in context and explain the first action. |
| [Noir for Mac](https://apps.apple.com/us/app/noir-dark-mode-for-safari/id1592917505?mt=12&platform=mac&see-all=reviews) | U.S. Mac reviews page displayed 4.4/5 from 361 ratings. | Show the visible change rather than relying on a large feature list. |

The first screenshots from these three official listings were visually inspected. Their observed conventions are design references, not proof that a particular background, headline, or layout caused sales. No competitor graphics, ratings, award badges, or endorsements are included in Marcos’s assets. Counts may change and the iTunes lookup endpoint returned zero rating counts, so the values above refer specifically to the public reviews pages.

## Category and offer

**Primary category: Utilities.** Marcos performs a specific system-level task: applying and controlling a screen tint. This matches [Apple’s Utilities category definition](https://developer.apple.com/app-store/categories/). Health & Fitness would imply a different primary purpose. The listing makes no medical, sleep, or eye-protection claims. A secondary category is left unset rather than forcing a weaker fit.

**Free, no in-app purchases, no subscriptions.** The product already has no billing system. In App Store Connect, select the free price point. [Apple’s pricing instructions](https://developer.apple.com/help/app-store-connect/manage-app-pricing/set-a-price/) are the source for the pricing setup; free pricing was subsequently saved in all 175 regions.

**Worldwide, general audience.** Select All Countries or Regions to include current and future App Store territories, per [Apple’s availability instructions](https://developer.apple.com/help/app-store-connect/manage-your-apps-availability/manage-availability-for-your-app-on-the-app-store/). Answer the content questionnaire from the app’s actual behavior; the expected base rating is 4+, without a higher-age override. Apple calculates regional ratings. General audience does not mean selecting the Made for Kids category. See [Apple’s age-rating workflow](https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating/). Account-specific legal and territory requirements still have to be resolved in the authenticated account.

## Search and first impression

[Apple’s product-page guidance](https://developer.apple.com/app-store/product-page/) recommends real UI, a strong first screenshot, focused subsequent images, and showing Dark Mode when supported. It limits keywords to 100 characters and advises against duplicate terms, competitor names, and irrelevant keywords. These rules informed the title, subtitle, keyword field, and five-image sequence. No search-volume estimates were available, so keywords are chosen for intent and product relevance.

The name **Marcos: Screen Tint** identifies the function immediately. **Warm colors. One click away.** adds an approachable benefit. The revised first image shows a physical silver MacBook with an unmistakable red tint across its entire display, including the menu bar and document, beside a controls inset based on the native capture. Later images answer practical questions in order: available colors, strength range, connected displays, and daily use/privacy. Large headings remain readable when the store reduces the landscape images.

## Asset construction

All five exports are 2880 × 1800, 16:10, sRGB JPEGs without alpha, matching one of [Apple’s accepted Mac screenshot sizes](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications). Images 2–5 embed captures from the production `FilterControls` SwiftUI view, rendered in light and dark appearances with isolated temporary settings. The revised first image is an AI-generated physical MacBook render and a controls inset based on that native capture; it is not a literal photograph or a pixel-identical UI capture. The artwork does not introduce new app controls or login automation. The desktop examples are original illustrations, visibly labeled, using the app’s exact tint color and opacity formula. UI captures are enlarged for readability. The Mac UI and promotional text remain English.

The image order is deliberate: the first image sells the result, the next two show choice and control, and the final two address multi-display use and ongoing trust. The writing mechanism is a human benefit followed by a visible, specific demonstration. It adapts the reasoning in the Apple copywriting study rather than copying Apple’s slogans.

## Measuring after launch

Do not call these the best-converting screenshots without Marcos’s own evidence. [Apple’s product-page optimization documentation](https://developer.apple.com/help/app-store-connect/create-product-page-optimization-tests/overview-of-product-page-optimization/) describes iOS/iPadOS treatments, so a native Mac A/B-test facility is not assumed here. Review the metrics available for the Mac app in App Store Connect after launch. Compare acquisition and product-page performance by country and referral source, and change one major creative element at a time. Sequential comparisons remain directional because traffic mix and seasonality can change. No advertising spend or campaign has been created.

## Approval and account boundary

The user reviewed and approved the revised MacBook hero before publication. Version 1.2.3, build 6, all five screenshots, and the listing were submitted on November 27, 2026. The verified status is Waiting for Review, with automatic release after approval. Utilities, free pricing, worldwide availability including future territories, general-audience ratings, and privacy responses are saved in App Store Connect. See [the submission record](BuildStatus.md). No public App Store release is claimed before approval.
