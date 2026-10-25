package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CommandCenterNewsInfoRequest implements IModule
   {
      
      private static var _instance:CommandCenterNewsInfoRequest;
      
      public var newsInfo:Vector.<CommandCenterNewsClickedRequest>;
      
      public function CommandCenterNewsInfoRequest(param1:Vector.<CommandCenterNewsClickedRequest> = null)
      {
         super();
         if(param1 == null)
         {
            this.newsInfo = new Vector.<CommandCenterNewsClickedRequest>();
         }
         else
         {
            this.newsInfo = param1;
         }
      }
      
      public static function get instance() : CommandCenterNewsInfoRequest
      {
         return _instance || (_instance = new CommandCenterNewsInfoRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -8448;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:CommandCenterNewsClickedRequest = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.newsInfo.length > 0)
         {
            this.newsInfo.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = CommandCenterNewsClickedRequest(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.newsInfo.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:CommandCenterNewsClickedRequest = null;
         param1.writeShort(-8448);
         param1.writeByte(this.newsInfo.length);
         for each(_loc2_ in this.newsInfo)
         {
            _loc2_.write(param1);
         }
      }
   }
}

