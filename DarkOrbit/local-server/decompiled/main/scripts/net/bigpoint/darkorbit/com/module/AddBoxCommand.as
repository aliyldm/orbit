package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class AddBoxCommand extends AddMapEntityCommand
   {
      
      private static var _instance:AddBoxCommand;
      
      public var boxType:String = "";
      
      public function AddBoxCommand(param1:String = "", param2:int = 0, param3:int = 0, param4:String = "")
      {
         super(param1,param2,param3);
         this.boxType = param4;
      }
      
      public static function get instance() : AddBoxCommand
      {
         return _instance || (_instance = new AddBoxCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -4037;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.boxType = param1.readUTF();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-4037);
         super.write(param1);
         param1.writeUTF(this.boxType);
      }
   }
}

