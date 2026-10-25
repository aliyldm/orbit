package net.bigpoint.darkorbit.mvc.battlestationswindow.view.ratings.components
{
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import spark.components.Image;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   
   public class RateItemBase extends SkinnableContainer
   {
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _tooltipTextId:String;
      
      private var _value:int = -1;
      
      protected var _216149521_tooltipText:String;
      
      private var _1317367021statIcon:Image;
      
      private var _2025208835valueLabel:Label;
      
      public function RateItemBase()
      {
         super();
      }
      
      public function init(param1:String, param2:String) : void
      {
         this._tooltipTextId = param2;
         this.updateTooltipText();
         this.statIcon.source = ResourceManager.getBitmapData("battleStationsUI",param1);
      }
      
      public function set value(param1:Number) : void
      {
         this._value = param1;
         this.valueLabel.text = String(this._value);
         this.updateTooltipText();
      }
      
      private function updateTooltipText() : void
      {
         if(this._tooltipTextId)
         {
            this._tooltipText = BPLocale.getItem(this._tooltipTextId) + ": " + this._value;
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get _tooltipText() : String
      {
         return this._216149521_tooltipText;
      }
      
      protected function set _tooltipText(param1:String) : void
      {
         var _loc2_:Object = this._216149521_tooltipText;
         if(_loc2_ !== param1)
         {
            this._216149521_tooltipText = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_tooltipText",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get statIcon() : Image
      {
         return this._1317367021statIcon;
      }
      
      public function set statIcon(param1:Image) : void
      {
         var _loc2_:Object = this._1317367021statIcon;
         if(_loc2_ !== param1)
         {
            this._1317367021statIcon = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statIcon",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get valueLabel() : Label
      {
         return this._2025208835valueLabel;
      }
      
      public function set valueLabel(param1:Label) : void
      {
         var _loc2_:Object = this._2025208835valueLabel;
         if(_loc2_ !== param1)
         {
            this._2025208835valueLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"valueLabel",_loc2_,param1));
            }
         }
      }
   }
}

