package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetBlockUICommand implements IModule
   {
      
      private static var _instance:PetBlockUICommand;
      
      public var blocked:Boolean = false;
      
      public var blockAll:Boolean = false;
      
      public function PetBlockUICommand(param1:Boolean = false, param2:Boolean = false)
      {
         super();
         this.blocked = param1;
         this.blockAll = param2;
      }
      
      public static function get instance() : PetBlockUICommand
      {
         return _instance || (_instance = new PetBlockUICommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 246;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.blocked = param1.readBoolean();
         this.blockAll = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(246);
         param1.writeBoolean(this.blocked);
         param1.writeBoolean(this.blockAll);
      }
   }
}

