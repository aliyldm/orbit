package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.IGalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.core.CompositeView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   
   public class StatsView extends CompositeView
   {
      
      private var bg:Bitmap;
      
      private var uridiumValueLabel:TextField;
      
      private var extraEnergyValueLabel:TextField;
      
      public function StatsView(param1:Object, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function update(param1:Event = null) : void
      {
         var _loc2_:String = param1.type;
         switch(_loc2_)
         {
            case ApplicationEvent.NUMBERS_UPDATE:
               this.updateNumbers();
               break;
            case ApplicationEvent.URIDIUM_UPDATE:
               this.updateUridiumAmount();
               break;
            case ApplicationEvent.INIT_COMPLETE:
               this.init();
         }
      }
      
      private function updateNumbers() : void
      {
         this.updateUridiumAmount();
         if(this.extraEnergyValueLabel)
         {
            this.extraEnergyValueLabel.text = BPLocale.formatNumber((model as IGalaxyGateBuilderModel).getExtraEnergy());
         }
      }
      
      private function updateUridiumAmount() : void
      {
         if(this.uridiumValueLabel)
         {
            this.uridiumValueLabel.text = BPLocale.formatNumber((model as IGalaxyGateBuilderModel).getUridium());
         }
      }
      
      private function init() : void
      {
         var _loc1_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         var _loc2_:SWFFinisher = SWFFinisher(_loc1_.getLib("common"));
         this.bg = _loc2_.getEmbeddedBitmap("stats_bg");
         addChild(this.bg);
         this.createStaticTextField(this,22,10,BPLocale.getItemInCategory("galaxyGates","label_uridium"));
         this.uridiumValueLabel = this.createDefaultTextField(this,232,10);
         this.createStaticTextField(this,22,24,BPLocale.getItemInCategory("galaxyGates","label_extraEnergy"));
         this.extraEnergyValueLabel = this.createDefaultTextField(this,232,24);
         this.updateNumbers();
      }
      
      private function createDefaultTextField(param1:DisplayObjectContainer, param2:Number, param3:Number) : TextField
      {
         var _loc4_:TextField = new TextField();
         _loc4_.defaultTextFormat = Styles.ggBuilderPlainStdFmt;
         _loc4_.embedFonts = Styles.ggBuilderPlainStdEmbed;
         _loc4_.height = Styles.ggBuilderPlainStdFontHeight + 4;
         _loc4_.width = 100;
         _loc4_.textColor = 10802175;
         _loc4_.antiAliasType = AntiAliasType.ADVANCED;
         _loc4_.selectable = false;
         _loc4_.autoSize = TextFieldAutoSize.RIGHT;
         _loc4_.x = param2;
         _loc4_.y = param3;
         if(param1 != null)
         {
            param1.addChild(_loc4_);
         }
         return _loc4_;
      }
      
      private function createStaticTextField(param1:DisplayObjectContainer, param2:Number, param3:Number, param4:String) : Bitmap
      {
         var _loc5_:TextField = new TextField();
         _loc5_.defaultTextFormat = Styles.ggBuilderPlainStdFmt;
         _loc5_.text = param4;
         _loc5_.embedFonts = Styles.ggBuilderPlainStdEmbed;
         _loc5_.height = Styles.ggBuilderPlainStdFontHeight + 4;
         _loc5_.width = 100;
         _loc5_.textColor = 7039851;
         _loc5_.antiAliasType = AntiAliasType.ADVANCED;
         var _loc6_:Bitmap = new Bitmap(new BitmapData(_loc5_.width,_loc5_.height,true,0));
         _loc6_.bitmapData.draw(_loc5_);
         _loc6_.x = param2;
         _loc6_.y = param3;
         if(param1 != null)
         {
            param1.addChild(_loc6_);
         }
         return _loc6_;
      }
   }
}

