package net.bigpoint.darkorbit.mvc.traininggrounds
{
   import com.bigpoint.utils.bindables.BindablePointLite;
   import com.bigpoint.utils.bindables.BindableRotation;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.pattern.FullResourcePattern;
   
   public class SimpleShipDisplayTrait extends EntityTraitBase
   {
      
      public const rotation:BindableRotation = new BindableRotation();
      
      private var _res:FullResourcePattern;
      
      private var _loop:Boolean;
      
      private var _rotatable:Boolean;
      
      public function SimpleShipDisplayTrait(param1:FullResourcePattern, param2:Boolean, param3:Boolean)
      {
         super();
         this._loop = param3;
         this._rotatable = param2;
         this._res = param1;
      }
      
      public function get res() : FullResourcePattern
      {
         return this._res;
      }
      
      public function get position() : BindablePointLite
      {
         return owner.position;
      }
      
      public function get loop() : Boolean
      {
         return this._loop;
      }
      
      public function get rotatable() : Boolean
      {
         return this._rotatable;
      }
   }
}

