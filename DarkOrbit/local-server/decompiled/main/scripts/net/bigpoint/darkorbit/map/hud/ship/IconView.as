package net.bigpoint.darkorbit.map.hud.ship
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.traits.hud.IconTrait;
   import net.bigpoint.darkorbit.pattern.FullResourcePattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class IconView extends AbstractIconView
   {
      
      private var _trait:IconTrait;
      
      public function IconView(param1:IconTrait)
      {
         super();
         this._trait = param1;
         if(this._trait.iconId == "")
         {
            return;
         }
         var _loc2_:FullResourcePattern = PatternManager.getIconpattern(this._trait.iconId);
         ResourceManager.loadAndCall(_loc2_.srcKey,this.addIcon,[_loc2_]);
      }
      
      private function addIcon(param1:FullResourcePattern) : void
      {
         var _loc3_:Object = null;
         var _loc2_:FileCollectionFinisher = ResourceManager.fileCollection.getFinisher(param1.srcKey);
         if(_loc2_ is SWFFinisher)
         {
            _loc3_ = (_loc2_ as SWFFinisher).getEmbeddedObject(param1.resKey);
            if(_loc3_ is BitmapData)
            {
               _loc3_ = new Bitmap(_loc3_ as BitmapData);
            }
            this.addElement(_loc3_ as DisplayObject);
         }
         else
         {
            if(!(_loc2_ is ImageFinisher))
            {
               throw new Error("invalid Finisher");
            }
            this.addElement((_loc2_ as ImageFinisher).getBitmap());
         }
      }
      
      private function addElement(param1:DisplayObject) : void
      {
         var _loc2_:Rectangle = null;
         _loc2_ = param1.getBounds(param1);
         param1.x = -_loc2_.x;
         param1.y = -_loc2_.y;
         addChild(param1);
         sizeChanged.dispatch();
      }
   }
}

