package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanAddNewsRequest implements IModule
   {
      
      private static var _instance:ClanAddNewsRequest;
      
      public var newsMessage:String = "";
      
      public function ClanAddNewsRequest(param1:String = "")
      {
         super();
         this.newsMessage = param1;
      }
      
      public static function get instance() : ClanAddNewsRequest
      {
         return _instance || (_instance = new ClanAddNewsRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -6590;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.newsMessage = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-6590);
         param1.writeUTF(this.newsMessage);
      }
   }
}

