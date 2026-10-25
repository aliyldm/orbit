package net.bigpoint.darkorbit.map.model.traits
{
   import com.bigpoint.utils.bindables.BindableString;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import org.osflash.signals.Signal;
   
   public class UberDisplayTrait extends EntityTraitBase
   {
      
      public const playAnimationSignal:Signal = new Signal(String);
      
      public const state:BindableString = new BindableString("");
      
      public var debug:Boolean = false;
      
      private var _descriptor:XML;
      
      private var _decorators:Vector.<Object> = new Vector.<Object>();
      
      private var _visualSize3D:Number;
      
      public function UberDisplayTrait(param1:XML)
      {
         super();
         this._descriptor = param1;
         this._visualSize3D = this._descriptor.display3D.length() > 0 ? Number(this._descriptor.display3D[0].@visualSize) || 1 : 1;
      }
      
      public static function fromXML(param1:XML, param2:Boolean = true) : UberDisplayTrait
      {
         var _loc3_:UberDisplayTrait = null;
         var _loc4_:XML = null;
         if(param1.display2D.length() > 0 || param1.display3D.length() > 0)
         {
            _loc3_ = new UberDisplayTrait(param1);
            if(param2)
            {
               for each(_loc4_ in param1.decorator)
               {
                  _loc3_._decorators.push({
                     "id":String(_loc4_.@type),
                     "xml":_loc4_
                  });
               }
            }
         }
         return _loc3_;
      }
      
      public function get descriptor() : XML
      {
         return this._descriptor;
      }
      
      public function get decorators() : Vector.<Object>
      {
         return this._decorators;
      }
      
      public function playAnimation(param1:String) : void
      {
         this.playAnimationSignal.dispatch(param1);
      }
      
      public function get visualSize3D() : Number
      {
         return this._visualSize3D;
      }
   }
}

