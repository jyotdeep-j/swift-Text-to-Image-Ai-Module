//
//  Constants.swift
//  DreamAI
//
//  Created by iApp on 04/11/22.
//

import Foundation
import UIKit


struct AdMob {

}

struct APIDetail {
    
}

struct AppDetail{

}

struct kUserDefault{


}


func fontFamilyName(){
    for fontFamilyName in UIFont.familyNames{
        for fontName in UIFont.fontNames(forFamilyName: fontFamilyName){
            print("Family: \(fontFamilyName)     Font: \(fontName)")
        }
    }
}

enum AIStyle: CaseIterable {
//    case addModifiers
    case none
    case s1
    case s2
    case s3
    case s4
    case s5
    case s6
    case s7
    case s8
    case s9
    case s10
    case s11
    case s12
    case s13
    case s14
    case s15
    case s16
//    case s17
    case s18
    case s19
    case s20
    case s21
    case s22
    case s23
//    case s24
    case s25
    case s26
    case s27
    case s28
    /*case cutpro1
    case cutpro2
    case cutpro3
    case cutpro4
    case cutpro5
    case cutpro6
    case cutpro7
    case cutpro8
    case cutpro9
    case cutpro10
    case cutpro11
    case cutpro12
    case cutpro13
    case cutpro14
    case cutpro15*/
    
    
    func styleDetail() -> (isPro:Bool, title: String,imageName: String,prompt: String) {
        switch self {
        /*case .addModifiers:
            return (false,"Add\nModifiers","edit","")*/
        case .none:
            return (false,"No Style","noneIcon","")
        case .s1:
            return (false,"Uranus","nightCafe"," detailed matte painting, deep color, fantastical, intricate detail, splash screen, complementary colors, fantasy concept art, 8k resolution trending on Artstation Unreal Engine 5")
        case .s2:
            return (false,"Art Portrait","Artistic Portrait"," head and shoulders portrait, 8k resolution concept art portrait by Greg Rutkowski, Artgerm, WLOP, Alphonse Mucha dynamic lighting hyperdetailed intricately detailed Splash art trending on Artstation triadic colors Unreal Engine 5 volumetric lighting")
        case .s3:
            return (false,"Voyage","Bon Voyage"," 8k resolution concept art by Greg Rutkowski dynamic lighting hyperdetailed intricately detailed Splash art trending on Artstation triadic colors Unreal Engine 5 volumetric lighting Alphonse Mucha WLOP Jordan Grimmer orange and teal")
        case .s4:
            return (false,"Photo","photo"," Professional photography, bokeh, natural lighting, canon lens, shot on dslr 64 megapixels sharp focus")
        case .s5:
            return (false,"Dramatic","Epic"," Epic cinematic brilliant stunning intricate meticulously detailed dramatic atmospheric maximalist digital matte painting")
        case .s6:
            return (true,"Fantasy","Dark Fantasy"," a masterpiece, 8k resolution, dark fantasy concept art, by Greg Rutkowski, dynamic lighting, hyperdetailed, intricately detailed, Splash screen art, trending on Artstation, deep color, Unreal Engine, volumetric lighting, Alphonse Mucha, Jordan Grimmer, purple and yellow complementary colours")
        case .s7:
            return (false,"Anime","Anime"," Studio Ghibli, Anime Key Visual, by Makoto Shinkai, Deep Color, Intricate, 8k resolution concept art, Natural Lighting, Beautiful Composition")
        case .s8:
            return (true,"Comic Book","Comic"," Mark Brooks and Dan Mumford, comic book art, perfect, smooth")
        case .s9:
            return (true,"3D Character","CGI"," Pixar, Disney, concept art, 3d digital art, Maya 3D, ZBrush Central 3D shading, bright colored background, radial gradient background, cinematic, Reimagined by industrial light and magic, 4k resolution post processing")
        case .s10:
            return (false,"Neo","Neo Impressionist"," neo-impressionism expressionist style oil painting, smooth post-impressionist impasto acrylic painting, thick layers of colourful textured paint")
        case .s11:
            return (true, "Bang Art","pop art"," Screen print, pop art, splash screen art, triadic colors, digital art, 8k resolution trending on Artstation, golden ratio, symmetrical, rule of thirds, geometric bauhaus")
        case .s12:
            return (false, "B & W","B&W Portrait"," Close up portrait, ambient light, Nikon 15mm f/1.8G, by Lee Jeffries, Alessio Albi, Adrian Kuipers")
        case .s13:
            return (true, "Close-up","Color Portait"," Close-up portrait, color portrait, Linkedin profile picture, professional portrait photography by Martin Schoeller, by Mark Mann, by Steve McCurry, bokeh, studio lighting, canon lens, shot on dslr, 64 megapixels, sharp focus")
        case .s14:
            return (false,"Oil Painting","Oil Painting"," oil painting by James Gurney")
        case .s15:
            return (true, "Cosmic","Cosmic"," 8k resolution holographic astral cosmic illustration mixed media by Pablo Amaringo")
        case .s16:
            return (true, "Baleful","sinister"," sinister by Greg Rutkowski")
//        case .s17:
//            return ("Candy","Candy"," vibrant colors Candyland wonderland gouache swirls detailed")
        case .s18:
            return (true, "Divine","Heavenly"," heavenly sunshine beams divine bright soft focus holy in the clouds")
        case .s19:
            return (true, "Metaverse","3d"," trending on Artstation Unreal Engine 3D shading shadow depth")
        case .s20:
            return (true, "Dream","fantasy"," ethereal fantasy hyperdetailed mist Thomas Kinkade")
        case .s21:
            return (false, "Watercolor","Gouache"," gouache detailed painting")
        case .s22:
            return (true, "Flat Paint","Matte"," detailed matte painting")
        case .s23:
            return (false, "Coal","charcoal"," hyperdetailed charcoal drawing")
//        case .s24:
//            return (true,"Horror","Horror"," horror Gustave Doré Greg Rutkowski")
        case .s25:
            return (true,"Unusual","surreal"," surrealism Salvador Dali matte background melting oil on canvas")
        case .s26:
            return (true, "Gears","Steampunk"," steampunk engine")
        case .s27:
            return (true, "Cyberpunk","Cyberpunk"," cyberpunk 2099 blade runner 2049 neon")
        case .s28:
            return (false, "Synthwave","Retro"," synthwave neon retro")
       /* case .cutpro1:
            return ("Concept Art","Concept Art","")
        case .cutpro2:
            return ("Realistic Anime","Realistic Anime","")
        case .cutpro3:
            return ("Photorealistic","Photorealistic","")
        case .cutpro4:
            return ("Vector Art","Vector Art","")
        case .cutpro5:
            return ("Cute","Cute","")
        case .cutpro6:
            return ("West Coast","West Coast","")
        case .cutpro7:
            return ("Photo","01-photo","")
        case .cutpro8:
            return ("Dystopia","03-dystopia","")
        case .cutpro9:
            return ("Fantasy","04-fantasy","")
        case .cutpro10:
            return ("Cyber","05-cyber","")
        case .cutpro11:
            return ("Europat","06-europa","")
        case .cutpro12:
            return ("Ethereal","07-ethereal","")
        case .cutpro13:
            return ("Sci-Fi","10-sci-fi","")
        case .cutpro14:
            return ("Techpunk","11-techpunk","")
        case .cutpro15:
            return ("Ghibli","15-ghibli","")*/
        }
    }
}


struct AIArtDataModel{
    
    enum AspectRatio {
        case square
        case ratio2_3
        case ratio3_2
        case custom(CGSize)
        
        var aspectSize: CGSize{
            switch self{
            case . square:
                return CGSize(width: 512, height: 512)
            case .ratio2_3:
                return CGSize(width: 512, height: 768)
            case .ratio3_2:
                return CGSize(width: 768, height: 512)
            case .custom(let size):
                return size
            }
        }
    }
    
    enum AIStabileEngine: String, CaseIterable{
        case diffusion_v1
        case diffusion_v1_5
        case diffusion_512_v2_0
        case diffusion_768_v2_0
        case diffusion_512_v2_1
        case diffusion_768_v2_1
        case inpainting_v1_0
        case inpainting_512_v2_0
        
        
       /* stable-diffusion-v1
        stable-diffusion-v1-5
        stable-diffusion-512-v2-0
        stable-diffusion-768-v2-0
        stable-diffusion-512-v2-1
        stable-diffusion-768-v2-1
        stable-inpainting-v1-0
        stable-inpainting-512-v2-0*/
        
        
        func engine() -> (title: String, name: String){
            switch self{
            case .diffusion_v1:
                return (title:"Stable Diffusion v1.4", name: "stable-diffusion-v1-4")
            case .diffusion_v1_5:
                return (title:"Stable Diffusion v1.5", name: "stable-diffusion-v1-5")
            case .diffusion_512_v2_0:
                return (title:"Stable Diffusion v2.0", name: "stable-diffusion-512-v2-0")
            case .diffusion_768_v2_0:
                return (title:"Stable Diffusion v2.0-768", name: "stable-diffusion-768-v2-0")
            case .diffusion_512_v2_1:
                return (title:"Stable Diffusion v2.1", name: "stable-diffusion-512-v2-1")
            case .diffusion_768_v2_1:
                return (title:"Stable Diffusion v2.1-768", name: "stable-diffusion-768-v2-1")
            case .inpainting_v1_0:
                return (title:"Stable Inpainting v1.0", name: "stable-inpainting-v1-0")
            case .inpainting_512_v2_0:
                return (title:"Stable Inpainting v2.0-512", name: "stable-inpainting-512-v2-0")
           
            }
        }
    }
    
    enum SamplerEngine: String, CaseIterable{
        case Automatic
        case ddim
        case plms
        case k_euler
        case k_euler_ancestral
        case k_heun
        case k_dpm_2
        case k_dpm_2_ancestral
        case k_lms
        case k_dpmpp_2s_ancestral
        case k_dpmpp_2m
    }
    
    
    enum MostPopularPrompt: CaseIterable{
        case prompt1
        case prompt2
        case prompt3
        case prompt4
        case prompt5
        case prompt6
        case prompt7
        case prompt8
        case prompt9
        case prompt10
        case prompt11
        case prompt12
        case prompt13
        case prompt14
        case prompt15
        case prompt16
        case prompt17
        case prompt18
        case prompt19
        case prompt20
        case prompt21
        case prompt22
        case prompt23
        case prompt24
        case prompt25
        case prompt26
        case prompt27
        case prompt28
        func styleDetail() -> (imageName: String,prompt: String) {
            switch self{
            case .prompt1:
                return ("abeautifulvibrantaspiring","a beautiful vibrant aspiring painting of the wise mechanical insectoid shape shifters in a complex fractal time universe, by Gustav Doré and Frank Xavier Leyendecker, Perspective, trending on ConceptArtWorld")
            case .prompt2:
                return ("Adreamofadistantgalaxy","A dream of a distant galaxy, trending on artstation HQ")
            case .prompt3:
                return ("a pink scene everything is pink","a pink scene, everything is pink, perfect pink shading, pink atmospheric lighting, by makoto shinkai, stanley artgerm lau, wlop, rossdraws")
            case .prompt4:
                return ("bright white_1.2","a very beautiful highly detailed (bright white_1.2), by (Ross Tran, rossdraws and filip hodas_0.9), fantasy concept art, trending on Artstation")
            case .prompt5:
                return ("Black skin blue eyes_1.2","a very beautiful highly detailed (Black skin blue eyes_1.2), by (Greg Rutkowski and james jean_0.9), fantasy concept art, trending on Artstation")
            case .prompt6:
                return ("Owlbear_1.2","a very beautiful highly detailed (Owlbear_1.2), by (andree wallin and Richard Anderson_0.9), fantasy concept art, trending on Artstation")
            case .prompt7:
                return ("detailed Warrior Modal","a very beautiful highly detailed Warrior. Modal. Highly detailed. Barbarian. Celtic. Pict. Portrait. Mist and rain. Dark face_1.2), by (andree wallin and filip hodas_0.9), fantasy concept art, trending on Artstation")
            case .prompt8:
                return ("cyborg woman","cyborg woman| with a visible detailed brain| muscles cable wires| biopunk| cybernetic| cyberpunk| white marble bust| canon m50| 100mm| sharp focus| smooth| hyperrealism| highly detailed| intricate details| carved by michelangelo")
            case .prompt9:
                return ("honeycombon","honeycomb tree house height definition 3D amazing structure detailed matte painting, deep color, fantastical, intricate detail, splash screen, complementary colors, fantasy concept art, 8k resolution trending on Artstation Unreal Engine 5 deep color")
            case .prompt10:
                return ("Huge flying white","Huge flying white cauliflower over the New York city, Alphonse Mucha dynamic lighting hyperdetailed intricately detailed Artstation triadic colors Unreal Engine 5 volumetric lighting ethereal elemental elegant")
            case .prompt11:
                return ("snoop dogg","snoop dogg, cinematic lighting, portrait oil paint on canvas, Johannes Vermeer, 8k")
            case .prompt12:
                return ("super cute fluffy cat","super cute fluffy cat warrior in armor, photorealistic, 4K, ultra detailed, vray rendering, unreal engine, midjourneyart style")
            case .prompt13:
                return ("detailed retrofuturistic","a beautiful highly detailed retrofuturistic mechanical Technical drawing of a lightsaber, parts labeled, specs detailed, blueprints on a sci fi workbench concept art, masterwork, digital art by Ross Tran, rossdraws and ismail inceoglu, ste")
            case .prompt14:
                return ("hyper-realistic anime","a beautiful hyper-realistic anime Creepy sharp Teeth, painted by greg rutkowski makoto shinkai takashi takeuchi studio ghibli, akihiko yoshida, clean soft lighting, finely detailed features, high-resolution, perfect art, stunning atmospher")
            case .prompt15:
                return ("realistic anime garfield","a beautiful hyper-realistic anime garfield in the altar, painted by greg rutkowski makoto shinkai takashi takeuchi studio ghibli, akihiko yoshida, anime, clean soft lighting, finely detailed features, high-resolution, perfect art, stunning")
            case .prompt16:
                return ("hyper-realistic anime jimi hendrix","a beautiful hyper-realistic anime jimi hendrix playing strat, painted by greg rutkowski makoto shinkai takashi takeuchi studio ghibli, akihiko yoshida, anime, clean soft lighting, finely detailed features, high-resolution, perfect art, stu")
            case .prompt17:
                return ("hyper-realistic anime Nine-tailed fox","a beautiful hyper-realistic anime Nine-tailed fox, painted by greg rutkowski makoto shinkai takashi takeuchi studio ghibli, akihiko yoshida, anime, clean soft lighting, finely detailed features, high-resolution, perfect art, stunning atmos")
            case .prompt18:
                return ("realistic anime Pokemon Fakemon","a beautiful hyper-realistic anime Pokemon Fakemon Lineart Cartoon Creature Concept, dragon, anime, green, purple, painted by greg rutkowski makoto shinkai takashi takeuchi studio ghibli, akihiko yoshida, anime, clean soft lighting, finely ")
            case .prompt19:
                return ("hyper-realistic anime Silent hill giger brom","a beautiful hyper-realistic anime Silent hill giger brom michael hussar bald female catalog shot luminous portrait soaking wet, painted by greg rutkowski makoto shinkai takashi takeuchi studio ghibli, akihiko yoshida, anime, clean soft lig")
            case .prompt20:
                return ("a highly detailed futuristic nighttime","a highly detailed futuristic nighttime, neon, nice professional photo of a beautiful pretty cute synth cyborg man tattooed bald perfect lovely face in analog film 35mm, cyberpunk, 4k, octane render, hyper detailed, bokeh, disposable camera")
            case .prompt21:
                return ("futuristic nighttime, neon, nice professional","a highly detailed futuristic nighttime, neon, nice professional photo of a beautiful pretty cute synth cyborg woman tattooed pink hair blue hair with perfect lovely face in analog film 35mm, cyberpunk, 4k, octane render, hyper detailed, bo")
            case .prompt22:
                return ("Beautiful portrait, black and white","a very beautiful highly detailed (Beautiful portrait, black and white, beautiful 20 year-old Irish woman with a loose braid in a bun, pale skin, profile, long neck_1.2), by (peter mohrbacher and mark keathley_0.9), fantasy concept art, tre")
            case .prompt23:
                return ("detailed Sacred white hair fox japanese","a very beautiful highly detailed Sacred white hair fox japanese goddess, beautiful eyes, kimono, human body with big fox ears on head, nature background, resolution concept art portrait by Greg Rut, kowski, Artgerm, WLOP, Alphonse Mucha dy")
            case .prompt24:
                return ("anoldpaintingofar","an old painting of a rainstorm with a rainbow, by Ismail Inceoglu, Zdzisław Beksiński, Gustave Doré, digital illustration, digital artwork, hyperdetailed digital painting, unique composition, masterpiece, photorealism, lo-fi hypermaxima")
            case .prompt25:
                return ("closeup portrait shot of a female Aztek Warrior","closeup portrait shot of a female Aztek Warrior in an epic battle environment, intricate, elegant, highly detailed, centered, digital painting, artstation, concept art, smooth, sharp focus, illustration, artgerm, tomasz alen kopera, peter ")
            case .prompt26:
                return ("Deadly green gas as a fog that is ove","Deadly green gas as a fog that is over a lake in the forest, fantasy art, concept art, hyper detailed, beautiful, complex, detailed, dystopian, elaborate, ethereal, flickering light, holographic, glowing neon, hyperdetailed, iridescent, my")
            case .prompt27:
                return ("goddess close-up portrait skull with mohawk","goddess close-up portrait skull with mohawk, ram skull, skeleton, thorax, x-ray, backbone, jellyfish phoenix head, nautilus, orchid, skull, betta fish, bioluminiscent creatures, intricate artwork by Tooth Wu and wlop and beeple. octane ren")
            case .prompt28:
                return ("Strange epic ultrawide aerial ultra-detailed","Strange epic ultrawide aerial ultra-detailed perfect close view of planet Jupiter clouds, by Zeitgeist, Artstation, Greg Rutkowski, hyperdetailed matte painting insanely detailed and intricate maximalist elegant striking hyper real paintin")
            }
        }
    }
    
    enum PromptIdeasForAIArt: CaseIterable{
        case prompt1
        case prompt2
        case prompt3
        case prompt4
        case prompt5
        case prompt6
        case prompt7
        case prompt8
        case prompt9
        case prompt10
        case prompt11
        case prompt12
        case prompt13
        case prompt14
        case prompt15
        case prompt16
        case prompt17
        case prompt18
        case prompt19
        case prompt20
        case prompt21
        case prompt22
        case prompt23
        case prompt24
        case prompt25
        case prompt26
        case prompt27
        case prompt28
        
        
        case prompt29
        case prompt30
        case prompt31
        case prompt32
        case prompt33
        case prompt34
        case prompt35
        case prompt36
        case prompt37
        case prompt38
        case prompt39
        case prompt40
        case prompt41
        case prompt42
        case prompt43
        case prompt44
        case prompt45
        case prompt46
        case prompt47
        case prompt48
        case prompt49
        case prompt50
        case prompt51
        case prompt52
        case prompt53
        case prompt54
        case prompt55
        case prompt56
        /*{
            "id": 10,
            "propmt": "3d fluffy baby penguin walking , cute and adorable, long fuzzy fur, Pixar render, unreal engine cinematic smooth, intricate detail, cinematic",
            "resultImages": [{
                "imageName": "3d fluffy baby penguin walking"
            }]
        }*/
        func promptIdeas() -> (imageName: String, promptText: String){
            switch self{
            case .prompt1:
                return ("3d fluffy baby penguin walking","3d fluffy baby penguin walking , cute and adorable, long fuzzy fur, Pixar render, unreal engine cinematic smooth, intricate detail, cinematic")//Done
            case .prompt2:
                return ("3d fluffy baby Shiba Inu walking","3d fluffy baby Shiba Inu walking , cute and adorable, long fuzzy fur, Pixar render, unreal engine cinematic smooth, intricate detail, cinematic")//Done
            case .prompt3:
                return ("a bonsai inside of a glass case","a bonsai inside of a glass case, an intricate and hyperdetailed painting by thomas eakins, ZBrush Central, fantasy art, album cover art, Studio Ghibli, Anime Key Visual, by Makoto Shinkai, Deep Color, Intricate, 8k resolution concept art, N")//Done
            case .prompt4:
                return ("A cute dragon surrounded","A cute dragon surrounded by luminous crystals, hyperdetailed and highly intricate digital illustration by Ismail Inceoglu, james jean, Anton Fadeev and Yoshitaka Amano, trending on artstation, Vibrant Colours, volumetric lighting, backlit")//Done
            case .prompt5:
                return ("a dying tree inside of a jail cell","a dying tree inside of a jail cell, an intricate and hyperdetailed painting by thomas eakins, ZBrush Central, fantasy art, album cover art,detailed matte painting, deep color, fantastical, intricate detail, splash screen, complementary colo")//Done
            case .prompt6:
                return ("a galactical storm epic landscape","a galactical storm epic landscape pink and violet")//Done
            case .prompt7:
                return ("A lady from behind in a red dress","A lady from behind in a red dress holding a rose, dark, head and shoulders portrait, 8k resolution concept art portrait by Greg Rutkowski, Artgerm, WLOP, Alphonse Mucha dynamic lighting hyperdetailed intricately detailed Splash art trending")//Done
            case .prompt8:
                return ("a seed sprouting from the cracks","a seed sprouting from the cracks of a dark jail cell, detailed matte painting, deep color, fantastical, intricate detail, splash screen, complementary colors, fantasy concept art, 8k resolution trending on Artstation Unreal Engine 5")//Done
            case .prompt9:
                return ("A small temple in the mountains","A small temple in the mountains, overlooking a sunrise, giant trees, Highly detailed, surrealism, octane render, 8k, 4k, Unreal Engine")//Done
            case .prompt10:
                return ("cherry blossom flowers falling","cherry blossom flowers falling from the tree and sky, grass field on a beautiful sunny day, Studio Ghibli, Anime Key Visual, by Makoto Shinkai, Deep Color, Intricate, 8k resolution concept art, Natural Lighting, Beautiful Composition")//Done
            case .prompt11:
                return ("cherry blossom trees lining a street","cherry blossom trees lining a street and a dragon in the sky, a masterpiece, 8k resolution, dark fantasy concept art, by Greg Rutkowski, dynamic lighting, hyperdetailed, intricately detailed, Splash screen art, trending on Artstation, deep ")//Done
            case .prompt12:
                return ("crashlanded Boeing","crashlanded Boeing, Forestpunk, Nature, organic, glow, sparkle, gloom, magical, mystic,thicket, jungle, overgrown, fractalcore, entropy, octane render, 8k")//Done
            case .prompt13:
                return ("cyborg-jesus","cyborg-jesus, Forestpunk, Nature, organic, glow, sparkle, gloom, magical, mystic,thicket, jungle, overgrown, fractalcore, entropy, octane render, 8k")//Done
            case .prompt14:
                return ("dutch angle photo silhouette","dutch angle photo silhouette of a mclaren p1 with the car lights piercing the dense fog, low light, dark mode")//Done
            case .prompt15:
                return ("Entire Giant and fabulous white","Entire Giant and fabulous white and glowy temple, made with igambling icons, sharp architecture, top of the hill, Horseshoe as rooftop, volumetric lighting, intricate detail, Overwatch art style, peaceful, sun rays, cinematic framing, UHD, ")//Done
            case .prompt16:
                return ("Face in flames","Face in flames, photography style, clear focus, hyperrealistic")//Done
            case .prompt17:
                return ("gates of heaven guarded by US Marines","gates of heaven guarded by US Marines, Epic cinematic brilliant stunning intricate meticulously detailed dramatic atmospheric maximalist digital matte painting")//Done
            case .prompt18:
                return ("Highly detailed and realistic beautiful","Highly detailed and realistic beautiful young African American female angel with halo with long curly hair in a realistic snowy Christmas village in the style of art by artgerm lau, digital art")//Done
            case .prompt19:
                return ("holographic Prismatic beautiful male","holographic Prismatic beautiful male Queztal in the air, in-action, colorful, inspired by yoji shinkawa")//Done
            case .prompt20:
                return ("hyperrealistic close up photo of an astronaut","hyperrealistic close up photo of an astronaut playing golf on the moon with the reflection of planet earth on the visor")//Done
            case .prompt21:
                return ("Jungle","Jungle, rainforest, cinematic lighting, volumetric lighting, shadow depth, digital art, dynamic composition, rule of thirds, 8 k resolution, trending on artstation, unreal engine 5")//Done
            case .prompt22:
                return ("Land plot","Land plot, intricate details, rich colors, beautiful lighting, V-Ray render, sun rays, photorealistic, isometric art,unreal engine,4K results, EOS 50D. iso 1300,photograph, extreme tilt shift, draw by Jacek Yerka,unreal engine")//Done
            case .prompt23:
                return ("n adorable Shiba Inu humanoid samurai","n adorable Shiba Inu humanoid samurai, a highly intricate and hyperdetailed matte photography, Greg Rutkowski, Remedios Varo, Ari Gibson, Catrin Welz-Stein, cover art, long exposure, stop motion, character design, 3d shading, 3DEXCITE, awar")//Done
            case .prompt24:
                return ("Rerolling style mix of Russell Dauterman","Rerolling style mix of Russell Dauterman, Jim lee, and Doug Mahnke], a Marvel Comic Book cover of the superhero Storm")//Done
            case .prompt25:
                return ("smiling happy golden doodle on sofa","smiling happy golden doodle on sofa, funny, comical, detailed, ultra-realistic, cinematic light, photorealistic, 8k, photography")//Done
            case .prompt26:
                return ("Space cat in an astronaut suit","Space cat in an astronaut suit")//Done
            case .prompt27:
                return ("the jetsons","the jetsons, in futuristic new york city, high rise apartment, flying cars, volumetric lighting, intricate detail, Overwatch art style, unreal engine 5")//Done
            case .prompt28:
                return ("yogi bear and boo boo","yogi bear and boo boo, at picnic, Forestpunk, Nature, organic, glow, sparkle, gloom, magical, mystic,thicket, jungle, overgrown, fractalcore, entropy, octane render, 8k")//Done
                
            case .prompt29:
                return ("abeautifulvibrantaspiring","a beautiful vibrant aspiring painting of the wise mechanical insectoid shape shifters in a complex fractal time universe, by Gustav Doré and Frank Xavier Leyendecker, Perspective, trending on ConceptArtWorld")//Done
            case .prompt30:
                return ("Adreamofadistantgalaxy","A dream of a distant galaxy, trending on artstation HQ")//Done
            case .prompt31:
                return ("a pink scene everything is pink","a pink scene, everything is pink, perfect pink shading, pink atmospheric lighting, by makoto shinkai, stanley artgerm lau, wlop, rossdraws")//Done
            case .prompt32:
                return ("bright white_1.2","a very beautiful highly detailed (bright white_1.2), by (Ross Tran, rossdraws and filip hodas_0.9), fantasy concept art, trending on Artstation")//Done
            case .prompt33:
                return ("Black skin blue eyes_1.2","a very beautiful highly detailed (Black skin blue eyes_1.2), by (Greg Rutkowski and james jean_0.9), fantasy concept art, trending on Artstation")//Done
            case .prompt34:
                return ("Owlbear_1.2","a very beautiful highly detailed (Owlbear_1.2), by (andree wallin and Richard Anderson_0.9), fantasy concept art, trending on Artstation")//Done
            case .prompt35:
                return ("detailed Warrior Modal","a very beautiful highly detailed Warrior. Modal. Highly detailed. Barbarian. Celtic. Pict. Portrait. Mist and rain. Dark face_1.2), by (andree wallin and filip hodas_0.9), fantasy concept art, trending on Artstation")//Done
            case .prompt36:
                return ("cyborg woman","cyborg woman| with a visible detailed brain| muscles cable wires| biopunk| cybernetic| cyberpunk| white marble bust| canon m50| 100mm| sharp focus| smooth| hyperrealism| highly detailed| intricate details| carved by michelangelo")//Done
            case .prompt37:
                return ("honeycombon","honeycomb tree house height definition 3D amazing structure detailed matte painting, deep color, fantastical, intricate detail, splash screen, complementary colors, fantasy concept art, 8k resolution trending on Artstation Unreal Engine 5 deep color")//Done
            case .prompt38:
                return ("Huge flying white","Huge flying white cauliflower over the New York city, Alphonse Mucha dynamic lighting hyperdetailed intricately detailed Artstation triadic colors Unreal Engine 5 volumetric lighting ethereal elemental elegant")//Done
            case .prompt39:
                return ("snoop dogg","snoop dogg, cinematic lighting, portrait oil paint on canvas, Johannes Vermeer, 8k")//Done
            case .prompt40:
                return ("super cute fluffy cat","super cute fluffy cat warrior in armor, photorealistic, 4K, ultra detailed, vray rendering, unreal engine, midjourneyart style")//Done
            case .prompt41:
                return ("detailed retrofuturistic","a beautiful highly detailed retrofuturistic mechanical Technical drawing of a lightsaber, parts labeled, specs detailed, blueprints on a sci fi workbench concept art, masterwork, digital art by Ross Tran, rossdraws and ismail inceoglu, ste")//Done
            case .prompt42:
                return ("hyper-realistic anime","a beautiful hyper-realistic anime Creepy sharp Teeth, painted by greg rutkowski makoto shinkai takashi takeuchi studio ghibli, akihiko yoshida, clean soft lighting, finely detailed features, high-resolution, perfect art, stunning atmospher")//Done
            case .prompt43:
                return ("realistic anime garfield","a beautiful hyper-realistic anime garfield in the altar, painted by greg rutkowski makoto shinkai takashi takeuchi studio ghibli, akihiko yoshida, anime, clean soft lighting, finely detailed features, high-resolution, perfect art, stunning")//Done
            case .prompt44:
                return ("hyper-realistic anime jimi hendrix","a beautiful hyper-realistic anime jimi hendrix playing strat, painted by greg rutkowski makoto shinkai takashi takeuchi studio ghibli, akihiko yoshida, anime, clean soft lighting, finely detailed features, high-resolution, perfect art, stu")//Done
            case .prompt45:
                return ("hyper-realistic anime Nine-tailed fox","a beautiful hyper-realistic anime Nine-tailed fox, painted by greg rutkowski makoto shinkai takashi takeuchi studio ghibli, akihiko yoshida, anime, clean soft lighting, finely detailed features, high-resolution, perfect art, stunning atmos")//Done
            case .prompt46:
                return ("realistic anime Pokemon Fakemon","a beautiful hyper-realistic anime Pokemon Fakemon Lineart Cartoon Creature Concept, dragon, anime, green, purple, painted by greg rutkowski makoto shinkai takashi takeuchi studio ghibli, akihiko yoshida, anime, clean soft lighting, finely ")//Done
            case .prompt47:
                return ("hyper-realistic anime Silent hill giger brom","a beautiful hyper-realistic anime Silent hill giger brom michael hussar bald female catalog shot luminous portrait soaking wet, painted by greg rutkowski makoto shinkai takashi takeuchi studio ghibli, akihiko yoshida, anime, clean soft lig")//Done
            case .prompt48:
                return ("a highly detailed futuristic nighttime","a highly detailed futuristic nighttime, neon, nice professional photo of a beautiful pretty cute synth cyborg man tattooed bald perfect lovely face in analog film 35mm, cyberpunk, 4k, octane render, hyper detailed, bokeh, disposable camera")//Done
            case .prompt49:
                return ("futuristic nighttime, neon, nice professional","a highly detailed futuristic nighttime, neon, nice professional photo of a beautiful pretty cute synth cyborg woman tattooed pink hair blue hair with perfect lovely face in analog film 35mm, cyberpunk, 4k, octane render, hyper detailed, bo")//Done
            case .prompt50:
                return ("Beautiful portrait, black and white","a very beautiful highly detailed (Beautiful portrait, black and white, beautiful 20 year-old Irish woman with a loose braid in a bun, pale skin, profile, long neck_1.2), by (peter mohrbacher and mark keathley_0.9), fantasy concept art, tre")//Done
            case .prompt51:
                return ("detailed Sacred white hair fox japanese","a very beautiful highly detailed Sacred white hair fox japanese goddess, beautiful eyes, kimono, human body with big fox ears on head, nature background, resolution concept art portrait by Greg Rut, kowski, Artgerm, WLOP, Alphonse Mucha dy")//Done
            case .prompt52:
                return ("anoldpaintingofar","an old painting of a rainstorm with a rainbow, by Ismail Inceoglu, Zdzisław Beksiński, Gustave Doré, digital illustration, digital artwork, hyperdetailed digital painting, unique composition, masterpiece, photorealism, lo-fi hypermaxima")//Done
            case .prompt53:
                return ("closeup portrait shot of a female Aztek Warrior","closeup portrait shot of a female Aztek Warrior in an epic battle environment, intricate, elegant, highly detailed, centered, digital painting, artstation, concept art, smooth, sharp focus, illustration, artgerm, tomasz alen kopera, peter ")//Done
            case .prompt54:
                return ("Deadly green gas as a fog that is ove","Deadly green gas as a fog that is over a lake in the forest, fantasy art, concept art, hyper detailed, beautiful, complex, detailed, dystopian, elaborate, ethereal, flickering light, holographic, glowing neon, hyperdetailed, iridescent, my")//Done
            case .prompt55:
                return ("goddess close-up portrait skull with mohawk","goddess close-up portrait skull with mohawk, ram skull, skeleton, thorax, x-ray, backbone, jellyfish phoenix head, nautilus, orchid, skull, betta fish, bioluminiscent creatures, intricate artwork by Tooth Wu and wlop and beeple. octane ren")//Done
            case .prompt56:
                return ("Strange epic ultrawide aerial ultra-detailed","Strange epic ultrawide aerial ultra-detailed perfect close view of planet Jupiter clouds, by Zeitgeist, Artstation, Greg Rutkowski, hyperdetailed matte painting insanely detailed and intricate maximalist elegant striking hyper real paintin")
            }
        }
        
    }
    
    enum Modifiers: CaseIterable{
        case nightCafe
        case artists
        case colors
        case artMovementsAndStyles
        case mediumsAndTechniques
        case photography
        case designToolsAndCommunities
        case descriptiveTerms
        case cultureGenre
        case classic
        
        var title: String{
            switch self{
            case .nightCafe:
                return "Our favorites"
            case .artists:
                return "Artists"
            case .colors:
                return "Colors"
            case .artMovementsAndStyles:
                return "Art movements and styles"
            case .mediumsAndTechniques:
                return "Mediums and techniques"
            case .photography:
                return "Photography"
            case .designToolsAndCommunities:
                return "Design tools and communities"
            case .descriptiveTerms:
                return "Descriptive terms"
            case .cultureGenre:
                return "Culture / genre"
            case .classic:
                return "Classic"
            }
        }
        
        var keywords: [String]{
            switch self{
            case .nightCafe:
                return ["8k resolution concept art", "art deco","art nouveau rococo architecture", "bokeh", "by Greg Rutkowski",
                        "detailed matte painting", "dynamic lighting", "Eldritch", "gouache", "hyperdetailed","intricately detailed",
                        "Splash art", "trending on Artstation", "triadic colors", "Ukiyo-e", "Unreal Engine", "volumetric lighting"]
            case .artists:
                return ["Alex Hirsch","Alphonse Mucha","Amanda Sage","Ben Bocquelet","Bernie Wrightson","Canaletto","Caspar David Friedrich","Claude Monet",
                        "Dan Mumford","Dan Witz","Edward Hopper","Ferdinand Knab","Gerald Brom","Greg Rutkowski","Guido Borelli","Gustav Klimt","Gustave Doré","H.R. Giger",
                        "J. G. Quintel","James Gurney","Jean Tinguely","Jim Burns","Jordan Grimmer","Josephine Wall","Julia Pott","Kandinsky","Kelly Freas","Killian Eng",
                        "Leonid Afremov","Max Ernst","Moebius","Pablo Picasso","Pendleton Ward","Pino Daeni","Rafael Santi","Rebecca Sugar","Roger Dean","Simon Stålenhag",
                        "Stephen Hillenburg","Steven Belledin","Studio Ghibli","Thomas Kinkade","Tim Burton","Van Gogh","Wadim Kashin","Wes Anderson","WLOP","Zdzisław Beksiński"]
            case .colors:
                return ["analogous colors","color corrected","color graded","color gradient","complementary colors","contrasting colors","cool colors","deep color",
                        "green and magenta","monochromatic","orange and teal","split-complementary colors","tetradic colors","triadic colors","warm colors","yellow and blue","yellow and purple"]
            case .artMovementsAndStyles:
                return ["academic art","action painting","art Brut","art deco","art Nouveau","ashcan school",
                        "Australian tonalism","baroque","bauhaus","brutalism","concept art","concrete art","cubism","cubist","detailed painting","expressionism","fauvism","film noir",
                        "filmic","fluxus","folk art","futurism","geometric abstract art","gothic art","graffiti","Harlem renaissance","Heidelberg school","hudson river school",
                        "hypermodernism","hyperrealism","impressionism","kinetic pointillism","lyrical abstraction","mannerism","matte painting","maximalism","maximalist",
                        "minimalism","minimalist","modern art","modern European ink painting","movie poster","naïve art","neo-primitivism","photorealism","pointillism","pop art",
                        "post-impressionism","poster art","pre-raphaelitism","precisionism","primitivism","psychedelic art","qajar art","renaissance painting","retrofuturism","romanesque",
                        "romanticism","shin hanga","splash art","storybook illustration","street art","surrealism","synthetism","Ukiyo-e","underground comix","vorticism"]
            case .mediumsAndTechniques:
                return ["8bit","acrylic art","airbrush art","ambient occlusion","brocade","cel-shaded","chalk art","charcoal drawing","collage",
                        "digital art","digital illustration","dye-transfer","faience","filigree","fractal","gouache","impasto","ink drawing","kintsugi","majolica",
                        "mandelbrot","mandelbulb","mixed media","mosaic","needlepoint","oil on canvas","pastels","pencil sketch","photoillustration","pixel art","quilling",
                        "resin cast","retroism","stipple","tesselation","thermal imaging","volumetric lighting","watercolor","wet brush","wet wash","woodcut"]
            case .photography:
                return ["#film","1900s photograph","4K","64 megapixels","8K resolution","back lit","bokeh","composite photograph","depth of field","diffuse light","DSLR",
                        "dynamic lighting","filmic","fisheye lens","golden hour","HDR", "Kodak Ektar","lens flare","long exposure","macro lens","macro photography","medium shot",
                        "motion blur","panorama","polaroid","retouched","sepia","sharp focus","silver nitrate photo","soft focus","stock photo","subtractive lighting","telephoto",
                        "telephoto lens","tilt-shift","unsplash","vignette","wide-angle lens"]
            case .designToolsAndCommunities:
                return ["3D shading","3Delight","3DEXCITE","3ds Max","AppGameKit",
                        "Art of Illusion","Artrift","AutoCAD","Behance HD","cel-shaded","CGSociety","Cinema 4D","CryEngine","deviantart","Doodle Addicts","finalRender","Flickr",
                        "Horde3D","IMAX","LightWave 3D","Mandelbulber3d","Octane Render","pixiv","Polycount","r/Art","rendered in Blender","shadow depth","Sketchfab","Sketchlab",
                        "Substance Designer","trending on Artstation","Unity 3D","Unreal Engine","Unreal Engine 5","Unsplash","volumetric lighting","VRay","ZBrush","ZBrush Central"]
            case .descriptiveTerms:
                return ["18th century atlas","1900s photograph","astral","aurora","beautiful","bismuth","colorful","complex",
                        "cosmic","crepuscule","dendritic","detailed","diffuse","dystopian","earth art","elaborate","eldritch","elegant","elemental","entangled","ethereal",
                        "expansive","fantastical","fire","firey","flickering light","futuristic","galactic","geometric","glowing neon","golden hour","golden ratio","gossamer",
                        "heat wave","holographic","hyperdetailed","infinity","intricate","iridescent","landscape","light dust","liminal","liminal space","low poly","magnificent",
                        "matte background","meticulous","moonscape","mysterious","noctilucent","ominous","ouroboros","parallax","photorealistic","polished","post-apocalyptic",
                        "psychedelic","radiant","retro","seascape","serene","space","spiraling","stygian","sunny","sunshine rays","synesthesia","thunderstorm","tornadic","twilight","vapor"]
            case .cultureGenre:
                return ["aetherpunk","anime","auroracore","biopunk","cassette futurism", "clockpunk","comic art","cyberpunk","dark academia","dieselpunk","dreamcore","dystopian",
                        "fairycore","fantasy","fantasycore","futuristic","glitchcore","horror","landscape","post-apocalyptic","prehistoricore","retro","retrofuturism","sci-fi",
                        "solarpunk","spacecore","steampunk","synthwave","vaporwave","zombiecore"]
            case .classic:
                return ["#film","8K 3D","8k resolution","abstract","acrylic art",
                        "airbrush art","ambient occlusion","anime","art deco","artwork","beautiful","Behance HD","bokeh","chalk art","charcoal drawing","colourful",
                        "concept art","CryEngine","cubist","detailed painting","deviantart","digital illustration","DSLR","dye-transfer","fauvism","film noir","filmic",
                        "flickering light","Flickr","geometric","glowing neon","graffiti","H.R. Giger","HDR","holographic","hyperrealism","impasto","impressionism",
                        "ink drawing","iridescent","Jim Burns","Kandinsky","Kodak Ektar","low poly","lowbrow","Marvel Comics","matte background","matte painting",
                        "maximalist","minimalist","mixed media","oil on canvas","parallax","pencil sketch","photoillustration","Picasso","pixel art","pixiv","polished",
                        "pop art","poster art","psychedelic","quilling","renaissance painting","Sketchfab","steampunk","stipple","stock photo","storybook illustration",
                        "sunshine rays","surrealism","Thomas Kinkade","tilt shift","trending on Artstation","Unreal Engine","Van Gogh","volumetric lighting","VRay","watercolor","woodcut"]
            }
        }
    }
    
    static let randomArtKeyword = [" A red colored car.",
   " A black colored car.",
   " A pink colored car.",
   " A black colored dog.",
   " A red colored dog.",
   " A blue colored dog.",
   " A green colored banana.",
   " A red colored banana.",
   " A black colored banana.",
   " A white colored sandwich.",
   " A black colored sandwich.",
   " An orange colored sandwich.",
   " A pink colored giraffe.",
   " A yellow colored giraffe.",
   " A brown colored giraffe.",
   " A red car and a white sheep.",
   " A blue bird and a brown bear.",
   " A green apple and a black backpack.",
   " A green cup and a blue cell phone.",
   " A yellow book and a red vase.",
   " A white car and a red sheep.",
   " A brown bird and a blue bear.",
   " A black apple and a green backpack.",
   " A blue cup and a green cell phone.",
   " A red book and a yellow vase.",
   " A horse riding an astronaut.",
   " A pizza cooking an oven.",
   " A bird scaring a scarecrow.",
   " A blue coloured pizza.",
   " Hovering cow abducting aliens.",
   " A panda making latte art.",
   " A shark in the desert.",
   " An elephant under the sea.",
   " Rainbow coloured penguin.",
   " A fish eating a pelican.",
   " One car on the street.",
   " Two cars on the street.",
   " Three cars on the street.",
   " Four cars on the street.",
   " Five cars on the street.",
   " One dog on the street.",
   " Two dogs on the street.",
   " Three dogs on the street.",
   " Four dogs on the street.",
   " Five dogs on the street.",
   " One cat and one dog sitting on the grass.",
   " One cat and two dogs sitting on the grass.",
   " One cat and three dogs sitting on the grass.",
   " Two cats and one dog sitting on the grass.",
   " Two cats and two dogs sitting on the grass.",
   " Two cats and three dogs sitting on the grass.",
   " Three cats and one dog sitting on the grass.",
   " Three cats and two dogs sitting on the grass.",
   " Three cats and three dogs sitting on the grass.",
   " A triangular purple flower pot. A purple flower pot in the shape of a triangle.",
   " A triangular orange picture frame. An orange picture frame in the shape of a triangle.",
   " A triangular pink stop sign. A pink stop sign in the shape of a triangle.",
   " A cube made of denim. A cube with the texture of denim.",
   " A sphere made of kitchen tile. A sphere with the texture of kitchen tile.",
   " A cube made of brick. A cube with the texture of brick.",
   " A collection of nail is sitting on a table.",
   " A single clock is sitting on a table.",
   " A couple of glasses are sitting on a table.",
   " An illustration of a large red elephant sitting on a small blue mouse.",
   " An illustration of a small green elephant standing behind a large red mouse.",
   " A small blue book sitting on a large red book.",
   " A stack of 3 plates. A blue plate is on the top, sitting on a blue plate. The blue plate is in the middle, sitting on a green plate. The green plate is on the bottom.",
   " A stack of 3 cubes. A red cube is on the top, sitting on a red cube. The red cube is in the middle, sitting on a green cube. The green cube is on the bottom.",
   " A stack of 3 books. A green book is on the top, sitting on a red book. The red book is in the middle, sitting on a blue book. The blue book is on the bottom.",
   " An emoji of a baby panda wearing a red hat, green gloves, red shirt, and green pants.",
   " An emoji of a baby panda wearing a red hat, blue gloves, green shirt, and blue pants.",
   " A fisheye lens view of a turtle sitting in a forest.",
   " A side view of an owl sitting in a field.",
   " A cross-section view of a brain.",
   " A vehicle composed of two wheels held in a frame one behind the other, propelled by pedals and steered with handlebars attached to the front wheel.",
   " A large motor vehicle carrying passengers by road, typically one serving the public on a fixed route and for a fare.",
   " A small vessel propelled on water by oars, sails, or an engine.",
   " A connection point by which firefighters can tap into a water supply.",
   " A machine next to a parking space in a street, into which the driver puts money so as to be authorized to park the vehicle for a particular length of time.",
   " A device consisting of a circular canopy of cloth on a folding metal frame supported by a central rod, used as protection against rain or sometimes sun.",
   " A separate seat for one person, typically with a back and four legs.",
   " An appliance or compartment which is artificially kept cool and used to store food and drink.",
   " A mechanical or electrical device for measuring time.",
   " An instrument used for cutting cloth, paper, and other thin material, consisting of two blades laid one on top of the other and fastened in the middle so as to allow them to be opened and closed by a thumb and finger inserted through rings on the end of their handles.",
   " A large plant-eating domesticated mammal with solid hoofs and a flowing mane and tail, used for riding, racing, and to carry and pull loads.",
   " A long curved fruit which grows in clusters and has soft pulpy flesh and yellow skin when ripe.",
   " A small domesticated carnivorous mammal with soft fur, a short snout, and retractable claws. It is widely kept as a pet or for catching mice, and many breeds have been developed.",
   " A domesticated carnivorous mammal that typically has a long snout, an acute sense of smell, nonretractable claws, and a barking, howling, or whining voice.",
   " An organ of soft nervous tissue contained in the skull of vertebrates, functioning as the coordinating center of sensation and intellectual and nervous activity.",
   " An American multinational technology company that focuses on artificial intelligence, search engine, online advertising, cloud computing, computer software, quantum computing, e-commerce, and consumer electronics.",
   " A large keyboard musical instrument with a wooden case enclosing a soundboard and metal strings, which are struck by hammers when the keys are depressed. The strings' vibration is stopped by dampers when the keys are released and can be regulated for length and volume by two or three pedals.",
   " A type of digital currency in which a record of transactions is maintained and new units of currency are generated by the computational solution of mathematical problems, and which operates independently of a central bank.",
   " A large thick-skinned semiaquatic African mammal, with massive jaws and large tusks.",
   " A machine resembling a human being and able to replicate certain human movements and functions automatically.",
   " Paying for a quarter-sized pizza with a pizza-sized quarter.",
   " An oil painting of a couple in formal evening wear going home get caught in a heavy downpour with no umbrellas.",
   " A grocery store refrigerator has pint cartons of milk on the top shelf, quart cartons on the middle shelf, and gallon plastic jugs on the bottom shelf.",
   " In late afternoon in January in New England, a man stands in the shadow of a maple tree.",
   " An elephant is behind a tree. You can see the trunk on one side and the back legs on the other.",
   " A tomato has been put on top of a pumpkin on a kitchen stool. There is a fork sticking into the pumpkin. The scene is viewed from above.",
   " A pear cut into seven pieces arranged in a ring.",
   " A donkey and an octopus are playing a game. The donkey is holding a rope on one end, the octopus is holding onto the other. The donkey holds the rope in its mouth. A cat is jumping over the rope.",
   " Supreme Court Justices play a baseball game with the FBI. The FBI is at bat, the justices are on the field.",
   " Abraham Lincoln touches his toes while George Washington does chin-ups. Lincoln is barefoot. Washington is wearing boots.",
   " Tcennis rpacket.",
   " Bzaseball galove.",
   " Rbefraigerator.",
   " Dininrg tablez.",
   " Pafrking metr.",
   " A smafml vessef epropoeilled on watvewr by ors, sauls, or han engie.",
   " A sjmall domesticated carnivorious mammnal with sof fuh,y a sthort sout, and retracwtablbe flaws. It iw widexly kept as a pet or for catchitng mic, ad many breeds zhlyde beefn develvoked.",
   " An instqrumemnt used for cutting cloth, paper, axdz othr thdin mteroial, consamistng of two blades lad one on tvopb of the other and fhastned in tle mixdqdjle so as to bllow them txo be pened and closed by thumb and fitngesr inserted tgrough rings on kthe end oc thei vatndlzes.",
   " A domesticated carnivvorous mzammal that typicbally hfaas a lons sfnout, an acxujte sense off osmell, noneetractaaln crlaws, anid xbarkring,y howlingu, or whining rvoiche.",
   " A ldarge keybord msical instroument lwith a woden case enmclosig a qsouvnkboajrd and mfgtal strivgf, which are strucrk b hammrs when the nels are depresdsmed.f lhe strsingsj' vibration ie stopped by damperds when the keys re released and can bce regulavewdd for lengh and vnolume y two or three pedalvs.",
   " A train on top of a surfboard.",
   " A wine glass on top of a dog.",
   " A bicycle on top of a boat.",
   " An umbrella on top of a spoon.",
   " A laptop on top of a teddy bear.",
   " A giraffe underneath a microwave.",
   " A donut underneath a toilet.",
   " A hair drier underneath a sheep.",
   " A tennis racket underneath a traffic light.",
   " A zebra underneath a broccoli.",
   " A banana on the left of an apple.",
   " A couch on the left of a chair.",
   " A car on the left of a bus.",
   " A cat on the left of a dog.",
   " A carrot on the left of a broccoli.",
   " A pizza on the right of a suitcase.",
   " A cat on the right of a tennis racket.",
   " A stop sign on the right of a refrigerator.",
   " A sheep to the right of a wine glass.",
   " A zebra to the right of a fire hydrant.",
   " Acersecomicke.",
   " Jentacular.",
   " Matutinal.",
   " Peristeronic.",
   " Artophagous.",
   " Backlotter.",
   " Octothorpe.",
   " A church with stained glass windows depicting a hamburger and french fries.",
   " Painting of the orange cat Otto von Garfield, Count of Bismarck-Schönhausen, Duke of Lauenburg, Minister-President of Prussia. Depicted wearing a Prussian Pickelhaube and eating his favorite meal - lasagna.",
   " A baby fennec sneezing onto a strawberry, detailed, macro, studio light, droplets, backlit ears.",
   " A photo of a confused grizzly bear in calculus class.",
   " An ancient Egyptian painting depicting an argument over whose turn it is to take out the trash.",
   " A fluffy baby sloth with a knitted hat trying to figure out a laptop, close up, highly detailed, studio lighting, screen reflecting in its eyes.",
   " A tiger in a lab coat with a 1980s Miami vibe, turning a well oiled science content machine, digital art.",
   " A 1960s yearbook photo with animals dressed as humans.",
   " Lego Arnold Schwarzenegger.",
   " A yellow and black bus cruising through the rainforest.",
   " A medieval painting of the wifi not working.",
   " An IT-guy trying to fix hardware of a PC tower is being tangled by the PC cables like Laokoon. Marble, copy after Hellenistic original from ca. 200 BC. Found in the Baths of Trajan, 1506.",
   " 35mm macro shot a kitten licking a baby duck, studio lighting.",
   " McDonalds Church.",
   " Photo of an athlete cat explaining it's latest scandal at a press conference to journalists.",
   " Greek statue of a man tripping over a cat.",
   " An old photograph of a 1920s airship shaped like a pig, floating over a wheat field.",
   " Photo of a cat singing in a barbershop quartet.",
   " A painting by Grant Wood of an astronaut couple, american gothic style.",
   " An oil painting portrait of the regal Burger King posing with a Whopper.",
   " A keyboard made of water, the water is made of light, the light is turned off.",
   " Painting of Mona Lisa but the view is from behind of Mona Lisa.",
   " Hyper-realistic photo of an abandoned industrial site during a storm.",
   " A screenshot of an iOS app for ordering different types of milk.",
   " A real life photography of super mario, 8k Ultra HD.",
   " Colouring page of large cats climbing the eifel tower in a cyberpunk future.",
   " Photo of a mega Lego space station inside a kid's bedroom.",
   " A spider with a moustache bidding an equally gentlemanly grasshopper a good day during his walk to work.",
   " A photocopy of a photograph of a painting of a sculpture of a giraffe.",
   " A bridge connecting Europe and North America on the Atlantic Ocean, bird's eye view.",
   " A maglev train going vertically downward in high speed, New York Times photojournalism.",
   " A magnifying glass over a page of a 1950s batman comic.",
   " A car playing soccer, digital art.",
   " Darth Vader playing with raccoon in Mars during sunset.",
   " A 1960s poster warning against climate change.",
   " Illustration of a mouse using a mushroom as an umbrella.",
   " A realistic photo of a Pomeranian dressed up like a 1980s professional wrestler with neon green and neon orange face paint and bright green wrestling tights with bright orange boots.",
   " A pyramid made of falafel with a partial solar eclipse in the background.",
   " A storefront with 'Hello World' written on it.",
   " A storefront with 'Diffusion' written on it.",
   " A storefront with 'Text to Image' written on it.",
   " A storefront with 'NeurIPS' written on it.",
   " A storefront with 'Deep Learning' written on it.",
   " A storefront with 'Google Brain Toronto' written on it.",
   " A storefront with 'Google Research Pizza Cafe' written on it.",
   " A sign that says 'Hello World'.",
   " A sign that says 'Diffusion'.",
   " A sign that says 'Text to Image'.",
   " A sign that says 'NeurIPS'.",
   " A sign that says 'Deep Learning'.",
   " A sign that says 'Google Brain Toronto'.",
   " A sign that says 'Google Research Pizza Cafe'.",
   " New York Skyline with 'Hello World' written with fireworks on the sky.",
   " New York Skyline with 'Diffusion' written with fireworks on the sky.",
   " New York Skyline with 'Text to Image' written with fireworks on the sky.",
   " New York Skyline with 'NeurIPS' written with fireworks on the sky.",
   " New York Skyline with 'Deep Learning' written with fireworks on the sky.",
   " New York Skyline with 'Google Brain Toronto' written with fireworks on the sky.",
   " New York Skyline with 'Google Research Pizza Cafe' written with fireworks on the sky."]
    


    
    /*static let styles = [
        "All",
        "Hotpot Art 6",
         "Hotpot Art 5",
         "Hotpot Art 2",
         "Photo General 1",
         "Photo Volumetric 1",
         "Fantasy 1",
         "Fantasy 2",
         "Anime 1",
         "Anime Korean 1",
         "Pixel Art",
         "Comic Book 1",
         "Sketch 1",
         "Watercolor",
         "Oil Painting",
         "3D 1",
         "Sculpture",
         "Graffiti",
         "Doom 2",
         "Portrait 1",
         "Portrait Game",
         "Icon Black White",
         "Icon Flat",
         "Logo Clean 1",
         "Logo Detailed 1",
         "Acrylic Art",
         "Architecture General 1",
         "Architecture Interior 1",
         "Charcoal 1",
         "Sticker",
         "Steampunk",
         "Gothic",
         "Illustration Flat",
         "Illustration General",
         "Line Art"
]*/
    
}

struct Message{
    static let PHOTO_LIBRARY_ACCESS_MSG     =       "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access"
    static let CAMERA_ACCESS_MSG            =       "App does not have access to your camera. To enable access, tap settings and turn on Camera"
    static let Settings                     =       "Settings"
    static let OK                           =       "OK"
    static let YES                          =       "Yes"
    static let Cancel                       =       "Cancel"
    static let GALLERY                      =       "Gallery"
    static let Camera                       =       "Camera"
    static let SELECT_OPTION                =       "Choose Option"
}



struct Constants {
  struct INNER_RECT {
    static let X : CGFloat = 1.0
    static let Y : CGFloat = 1.0
  }
  
  struct SLIDER {
    static let WHOLE_PERCENT : CGFloat = 100.0
  }
  
}
