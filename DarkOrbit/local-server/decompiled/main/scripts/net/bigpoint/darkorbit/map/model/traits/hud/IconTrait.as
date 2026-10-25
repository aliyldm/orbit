package net.bigpoint.darkorbit.map.model.traits.hud
{
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   
   public class IconTrait extends EntityTraitBase
   {
      
      private var _iconId:String;
      
      public function IconTrait(param1:String = "")
      {
         super();
         this._iconId = param1;
      }
      
      public function get iconId() : String
      {
         return this._iconId;
      }
      
      public function set iconId(param1:String) : void
      {
         this._iconId = param1;
      }
   }
}

