package net.bigpoint.darkorbit.map.model.env
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.PartnerTypeModule;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import net.bigpoint.darkorbit.pattern.BannerAdPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class Billboard extends MapEntity
   {
      
      private static const PARTNER_TYPE_2_PATTERN_KEY:Object = {};
      
      private static const PARTNER_TYPE_2_BILLBOARD_TYPE:Object = {};
      
      private static const MAX_CLICKS:uint = 3;
      
      PARTNER_TYPE_2_PATTERN_KEY[PartnerTypeModule.PARTNERTYPE_ANTEC] = "partner_antec";
      PARTNER_TYPE_2_PATTERN_KEY[PartnerTypeModule.PARTNERTYPE_RAZER] = "partner_razer";
      PARTNER_TYPE_2_PATTERN_KEY[PartnerTypeModule.PARTNERTYPE_ROCCAT] = "partner_roccat";
      PARTNER_TYPE_2_PATTERN_KEY[PartnerTypeModule.PARTNERTYPE_DARKORBIT] = "partner_antec";
      PARTNER_TYPE_2_BILLBOARD_TYPE[PartnerTypeModule.PARTNERTYPE_ANTEC] = 1;
      PARTNER_TYPE_2_BILLBOARD_TYPE[PartnerTypeModule.PARTNERTYPE_RAZER] = 2;
      PARTNER_TYPE_2_BILLBOARD_TYPE[PartnerTypeModule.PARTNERTYPE_ROCCAT] = 3;
      PARTNER_TYPE_2_BILLBOARD_TYPE[PartnerTypeModule.PARTNERTYPE_DARKORBIT] = 1;
      
      private var _clickCount:uint = 0;
      
      private var _bannerAdPattern:BannerAdPattern;
      
      public function Billboard(param1:int, param2:Number, param3:Number, param4:uint)
      {
         super(param1,new PointLite(param2,param3));
         var _loc5_:String = PARTNER_TYPE_2_PATTERN_KEY[param4] || "partner_antec";
         this._bannerAdPattern = PatternManager.bannerAdPatterns[_loc5_] as BannerAdPattern;
         var _loc6_:int = int(int(PARTNER_TYPE_2_BILLBOARD_TYPE[param4]) || 1);
         UberAssetsLib.instance.fillTraits(this,"billboard_" + _loc6_,UberAssetsLib.LIB_DEFAULT,null,this.openPartnerURL);
      }
      
      private function openPartnerURL() : void
      {
         if(this._clickCount < MAX_CLICKS)
         {
            JavascriptProxy.call(JavascriptProxy.FUNCTION_REFER_TO_EXTERNAL_URL_IN_NEW_WINDOW,[this._bannerAdPattern.url,false]);
            ++this._clickCount;
         }
      }
      
      public function get bannerAdPattern() : BannerAdPattern
      {
         return this._bannerAdPattern;
      }
   }
}

