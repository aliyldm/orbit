package net.bigpoint.darkorbit.mvc.chatclient.view
{
   import flash.display.BitmapData;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.buttons.button.FadableButtonSkin;
   import net.bigpoint.darkorbit.fui.components.core.skins.SkinLayerNames;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.BitmapLayer;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   
   public class ChatUIIconSkinFactory
   {
      
      public static const ATLAS_XML_RESOURCE_ID:String = "chat_ui_icon_atlasXml";
      
      public static const TEXTURE_RESOURCE_ID:String = "chat_ui_icon_texture";
      
      public static const BITMAP_ATLAS_ID:String = "chatUIIconBitmapAtlas";
      
      public static const ICON_CLEAN:String = "chat_ui_clean";
      
      public static const ICON_EMOJI:String = "chat_ui_emoji";
      
      public static const ICON_MESSAGE:String = "chat_ui_message";
      
      public static const ICON_SETTING:String = "chat_ui_setting";
      
      public static const ICON_DEFAULT_AVATAR:String = "default_avatar";
      
      public static const ICON_FRACTION_PREFIX:String = "chat_fraction";
      
      public function ChatUIIconSkinFactory()
      {
         super();
      }
      
      public static function getIconBitmapData(param1:String) : BitmapData
      {
         var _loc2_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         if(!_loc2_ || !_loc2_.getBitmapAtlasById(BITMAP_ATLAS_ID))
         {
            return null;
         }
         return _loc2_.getBitmapDataFromAtlas(param1,BITMAP_ATLAS_ID);
      }
      
      public static function getFactionIconBitmapData(param1:int) : BitmapData
      {
         if(param1 < 1 || param1 > 3)
         {
            return null;
         }
         return getIconBitmapData(ICON_FRACTION_PREFIX + param1);
      }
      
      public static function applyTo(param1:Button, param2:String) : Boolean
      {
         var _loc9_:BitmapLayer = null;
         var _loc10_:BitmapLayer = null;
         if(!param1)
         {
            return false;
         }
         var _loc3_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         if(!_loc3_ || !_loc3_.getBitmapAtlasById(BITMAP_ATLAS_ID))
         {
            return false;
         }
         var _loc4_:BitmapData = getBitmapData(_loc3_,param2,"_normal");
         if(!_loc4_)
         {
            return false;
         }
         var _loc5_:BitmapData = getBitmapData(_loc3_,param2,"_hover") || _loc4_;
         var _loc6_:BitmapData = getBitmapData(_loc3_,param2,"_active") || _loc5_;
         var _loc7_:BitmapLayer = new BitmapLayer(_loc4_.clone());
         var _loc8_:BitmapLayer = new BitmapLayer(_loc5_.clone());
         _loc9_ = new BitmapLayer(_loc6_.clone());
         _loc10_ = new BitmapLayer(_loc4_.clone());
         _loc10_.alpha = 0.4;
         var _loc11_:FadableButtonSkin = new FadableButtonSkin();
         _loc11_.setSkinLayer(SkinLayerNames.NORMAL,_loc7_);
         _loc11_.setSkinLayer(SkinLayerNames.OVER,_loc8_);
         _loc11_.setSkinLayer(SkinLayerNames.CLICKED,_loc9_);
         _loc11_.setSkinLayer(SkinLayerNames.DISABLED,_loc10_);
         param1.text = "";
         param1.skin = _loc11_;
         return true;
      }
      
      private static function getBitmapData(param1:AssetsProxy, param2:String, param3:String) : BitmapData
      {
         return param1.getBitmapDataFromAtlas(param2 + param3,BITMAP_ATLAS_ID) || param1.getBitmapDataFromAtlas(param2,BITMAP_ATLAS_ID);
      }
   }
}

