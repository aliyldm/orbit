package net.bigpoint.darkorbit.mvc.questWindow.view.challengesSection.skins
{
   import mx.events.PropertyChangeEvent;
   import spark.components.Grid;
   import spark.components.gridClasses.IGridVisualElement;
   import spark.primitives.Rect;
   
   public class HighscoreTableSkinInnerClass0 extends Rect implements IGridVisualElement
   {
      
      private var _88844982outerDocument:HighscoreTableSkin;
      
      private var _1089252156headerLabelColor:String;
      
      public function HighscoreTableSkinInnerClass0()
      {
         super();
      }
      
      public function prepareGridVisualElement(param1:Grid, param2:int, param3:int) : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function get outerDocument() : HighscoreTableSkin
      {
         return this._88844982outerDocument;
      }
      
      public function set outerDocument(param1:HighscoreTableSkin) : void
      {
         var _loc2_:Object = this._88844982outerDocument;
         if(_loc2_ !== param1)
         {
            this._88844982outerDocument = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"outerDocument",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get headerLabelColor() : String
      {
         return this._1089252156headerLabelColor;
      }
      
      public function set headerLabelColor(param1:String) : void
      {
         var _loc2_:Object = this._1089252156headerLabelColor;
         if(_loc2_ !== param1)
         {
            this._1089252156headerLabelColor = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerLabelColor",_loc2_,param1));
            }
         }
      }
   }
}

