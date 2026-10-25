package net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.inventoryFilter.components
{
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOPopUp;
   import spark.components.Label;
   import spark.components.VGroup;
   
   public class PopUpWithInventoryFilterBase extends DOPopUp
   {
      
      private static var _skinParts:Object = {
         "moveArea":false,
         "closeButton":false,
         "controlBarGroup":false,
         "contentGroup":false,
         "titleDisplay":false,
         "resizeHandle":false
      };
      
      private var _2056601608toogleLabel:Label;
      
      private var _1229490301optionsContainer:VGroup;
      
      public function PopUpWithInventoryFilterBase()
      {
         super();
      }
      
      protected function creationCompleteHandler() : void
      {
         title = BPLocale.getItem("popup_bswin_title_filter_modules");
         this.toogleLabel.text = BPLocale.getItem("popup_bswin_message_filter_modules");
      }
      
      [Bindable(event="propertyChange")]
      public function get toogleLabel() : Label
      {
         return this._2056601608toogleLabel;
      }
      
      public function set toogleLabel(param1:Label) : void
      {
         var _loc2_:Object = this._2056601608toogleLabel;
         if(_loc2_ !== param1)
         {
            this._2056601608toogleLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"toogleLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get optionsContainer() : VGroup
      {
         return this._1229490301optionsContainer;
      }
      
      public function set optionsContainer(param1:VGroup) : void
      {
         var _loc2_:Object = this._1229490301optionsContainer;
         if(_loc2_ !== param1)
         {
            this._1229490301optionsContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"optionsContainer",_loc2_,param1));
            }
         }
      }
   }
}

