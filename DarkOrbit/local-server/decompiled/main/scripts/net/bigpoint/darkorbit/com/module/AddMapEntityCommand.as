package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AddMapEntityCommand implements IModule
   {
      
      private static var _instance:AddMapEntityCommand;
      
      public var y:int = 0;
      
      public var hash:String = "";
      
      public var x:int = 0;
      
      public function AddMapEntityCommand(param1:String = "", param2:int = 0, param3:int = 0)
      {
         super();
         this.y = param3;
         this.hash = param1;
         this.x = param2;
      }
      
      public static function get instance() : AddMapEntityCommand
      {
         return _instance || (_instance = new AddMapEntityCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 899;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.y = param1.readInt();
         this.y = this.y >>> 11 % 32 | this.y << 32 - 11 % 32;
         this.hash = param1.readUTF();
         this.x = param1.readInt();
         this.x = this.x << 1 % 32 | this.x >>> 32 - 1 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(899);
         param1.writeInt(this.y << 11 % 32 | this.y >>> 32 - 11 % 32);
         param1.writeUTF(this.hash);
         param1.writeInt(this.x >>> 1 % 32 | this.x << 32 - 1 % 32);
      }
   }
}

