package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ChannelCloseRequest implements IModule
   {
      
      private static var _instance:ChannelCloseRequest;
      
      public var close:Boolean = false;
      
      public function ChannelCloseRequest(param1:Boolean = false)
      {
         super();
         this.close = param1;
      }
      
      public static function get instance() : ChannelCloseRequest
      {
         return _instance || (_instance = new ChannelCloseRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 260;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.close = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(260);
         param1.writeBoolean(this.close);
      }
   }
}

