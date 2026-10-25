package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetIsDestroyedCommand implements IModule
   {
      
      private static var _instance:PetIsDestroyedCommand;
      
      public static const DESTROYEDTYPE_NONE:int = 0;
      
      public static const DESTROYEDTYPE_USED_KAMIKAZE:int = 1;
      
      public static const DESTROYEDTYPE__MAX:int = 2;
      
      public var destroyedType:int = 0;
      
      public function PetIsDestroyedCommand(param1:int = 0)
      {
         super();
         this.destroyedType = param1;
      }
      
      public static function get instance() : PetIsDestroyedCommand
      {
         return _instance || (_instance = new PetIsDestroyedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 227;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.destroyedType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(227);
         param1.writeShort(this.destroyedType);
      }
   }
}

