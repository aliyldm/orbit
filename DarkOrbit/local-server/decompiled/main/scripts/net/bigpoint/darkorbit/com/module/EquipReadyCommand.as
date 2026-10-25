package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EquipReadyCommand implements IModule
   {
      
      private static var _instance:EquipReadyCommand;
      
      public var ready:Boolean = false;
      
      public function EquipReadyCommand(param1:Boolean = false)
      {
         super();
         this.ready = param1;
      }
      
      public static function get instance() : EquipReadyCommand
      {
         return _instance || (_instance = new EquipReadyCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -11031;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.ready = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-11031);
         param1.writeBoolean(this.ready);
      }
   }
}

