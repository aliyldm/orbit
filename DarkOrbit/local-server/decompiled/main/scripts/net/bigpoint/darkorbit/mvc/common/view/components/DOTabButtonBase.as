package net.bigpoint.darkorbit.mvc.common.view.components
{
   import flash.display.Bitmap;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import spark.components.ButtonBarButton;
   
   public class DOTabButtonBase extends ButtonBarButton
   {
      
      private static var _skinParts:Object = {
         "labelDisplay":false,
         "iconDisplay":false
      };
      
      private var _1641208108factionGraphic:Bitmap;
      
      public function DOTabButtonBase()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         if(param1)
         {
            this.setFactionIcon(param1);
         }
      }
      
      protected function setFactionIcon(param1:Object) : void
      {
         if(Boolean(param1.hasOwnProperty("factionID")) && Boolean(ResourceManager.fileCollection.getFinisher("icons") as SWFFinisher) && (ResourceManager.fileCollection.getFinisher("icons") as SWFFinisher).hasEmbeddedObject("fraction" + param1["factionID"]))
         {
            this.factionGraphic = ResourceManager.getBitmap("icons","fraction" + param1["factionID"]);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get factionGraphic() : Bitmap
      {
         return this._1641208108factionGraphic;
      }
      
      public function set factionGraphic(param1:Bitmap) : void
      {
         var _loc2_:Object = this._1641208108factionGraphic;
         if(_loc2_ !== param1)
         {
            this._1641208108factionGraphic = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"factionGraphic",_loc2_,param1));
            }
         }
      }
   }
}

