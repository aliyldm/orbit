package away3d.library.naming
{
   import away3d.library.assets.IAsset;
   
   public class IgnoreConflictStrategy extends ConflictStrategyBase
   {
      
      public function IgnoreConflictStrategy()
      {
         super();
      }
      
      override public function resolveConflict(param1:IAsset, param2:IAsset, param3:Object, param4:String) : void
      {
      }
      
      override public function create() : ConflictStrategyBase
      {
         return new IgnoreConflictStrategy();
      }
   }
}

