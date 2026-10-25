package net.bigpoint.darkorbit.com.module.porting.SpaceSearch
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UpdateSpaceSearchKeyCommand implements IModule
   {
      
      private static var _instance:UpdateSpaceSearchKeyCommand;
      
      public var quantity:Number = 0;
      
      public function UpdateSpaceSearchKeyCommand(param1:Number = 0)
      {
         super();
         this.quantity = param1;
      }
      
      public static function get instance() : UpdateSpaceSearchKeyCommand
      {
         return _instance || (_instance = new UpdateSpaceSearchKeyCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -31102;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.quantity = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-31102);
         param1.writeDouble(this.quantity);
      }
   }
}

