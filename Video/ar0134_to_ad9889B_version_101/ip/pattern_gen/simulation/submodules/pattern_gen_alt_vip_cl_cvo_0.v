// pattern_gen_alt_vip_cl_cvo_0.v

// This file was auto-generated from alt_vip_cl_cvo_hw.tcl.  If you edit it your changes
// will probably be lost.
// 
// Generated using ACDS version 16.1 196

`timescale 1 ps / 1 ps
module pattern_gen_alt_vip_cl_cvo_0 #(
		parameter BPS                           = 8,
		parameter NUMBER_OF_COLOUR_PLANES       = 3,
		parameter COLOUR_PLANES_ARE_IN_PARALLEL = 1,
		parameter INTERLACED                    = 0,
		parameter H_ACTIVE_PIXELS               = 1920,
		parameter V_ACTIVE_LINES                = 1080,
		parameter ACCEPT_COLOURS_IN_SEQ         = 0,
		parameter FIFO_DEPTH                    = 1920,
		parameter CLOCKS_ARE_SAME               = 1,
		parameter USE_CONTROL                   = 1,
		parameter NO_OF_MODES                   = 1,
		parameter THRESHOLD                     = 1919,
		parameter STD_WIDTH                     = 1,
		parameter GENERATE_SYNC                 = 0,
		parameter LOW_LATENCY                   = 0,
		parameter USE_EMBEDDED_SYNCS            = 0,
		parameter AP_LINE                       = 0,
		parameter V_BLANK                       = 0,
		parameter H_BLANK                       = 0,
		parameter H_SYNC_LENGTH                 = 40,
		parameter H_FRONT_PORCH                 = 110,
		parameter H_BACK_PORCH                  = 220,
		parameter V_SYNC_LENGTH                 = 5,
		parameter V_FRONT_PORCH                 = 5,
		parameter V_BACK_PORCH                  = 20,
		parameter F_RISING_EDGE                 = 0,
		parameter F_FALLING_EDGE                = 0,
		parameter FIELD0_V_RISING_EDGE          = 0,
		parameter FIELD0_V_BLANK                = 0,
		parameter FIELD0_V_SYNC_LENGTH          = 0,
		parameter FIELD0_V_FRONT_PORCH          = 0,
		parameter FIELD0_V_BACK_PORCH           = 0,
		parameter ANC_LINE                      = 0,
		parameter FIELD0_ANC_LINE               = 0,
		parameter PIXELS_IN_PARALLEL            = 1,
		parameter SRC_WIDTH                     = 8,
		parameter DST_WIDTH                     = 8,
		parameter CONTEXT_WIDTH                 = 8,
		parameter TASK_WIDTH                    = 8
	) (
		output wire [23:0] clocked_video_vid_data,        //     clocked_video.vid_data
		output wire        clocked_video_underflow,       //                  .underflow
		output wire        clocked_video_vid_mode_change, //                  .vid_mode_change
		output wire        clocked_video_vid_std,         //                  .vid_std
		output wire        clocked_video_vid_datavalid,   //                  .vid_datavalid
		output wire        clocked_video_vid_v_sync,      //                  .vid_v_sync
		output wire        clocked_video_vid_h_sync,      //                  .vid_h_sync
		output wire        clocked_video_vid_f,           //                  .vid_f
		output wire        clocked_video_vid_h,           //                  .vid_h
		output wire        clocked_video_vid_v,           //                  .vid_v
		input  wire        main_clock_clk,                //        main_clock.clk
		input  wire        main_reset_reset,              //        main_reset.reset
		input  wire [23:0] din_data,                      //               din.data
		input  wire        din_valid,                     //                  .valid
		input  wire        din_startofpacket,             //                  .startofpacket
		input  wire        din_endofpacket,               //                  .endofpacket
		output wire        din_ready,                     //                  .ready
		output wire        status_update_irq_irq,         // status_update_irq.irq
		input  wire [7:0]  control_address,               //           control.address
		input  wire [3:0]  control_byteenable,            //                  .byteenable
		input  wire        control_write,                 //                  .write
		input  wire [31:0] control_writedata,             //                  .writedata
		input  wire        control_read,                  //                  .read
		output wire [31:0] control_readdata,              //                  .readdata
		output wire        control_readdatavalid,         //                  .readdatavalid
		output wire        control_waitrequest            //                  .waitrequest
	);

	wire         video_in_av_st_dout_valid;                 // video_in:av_st_dout_valid -> sop_align:av_st_din_valid
	wire  [55:0] video_in_av_st_dout_data;                  // video_in:av_st_dout_data -> sop_align:av_st_din_data
	wire         video_in_av_st_dout_ready;                 // sop_align:av_st_din_ready -> video_in:av_st_dout_ready
	wire         video_in_av_st_dout_startofpacket;         // video_in:av_st_dout_startofpacket -> sop_align:av_st_din_startofpacket
	wire         video_in_av_st_dout_endofpacket;           // video_in:av_st_dout_endofpacket -> sop_align:av_st_din_endofpacket
	wire         sop_align_av_st_dout_valid;                // sop_align:av_st_dout_valid -> cvo_core:av_st_din_valid
	wire  [55:0] sop_align_av_st_dout_data;                 // sop_align:av_st_dout_data -> cvo_core:av_st_din_data
	wire         sop_align_av_st_dout_ready;                // cvo_core:av_st_din_ready -> sop_align:av_st_dout_ready
	wire         sop_align_av_st_dout_startofpacket;        // sop_align:av_st_dout_startofpacket -> cvo_core:av_st_din_startofpacket
	wire         sop_align_av_st_dout_endofpacket;          // sop_align:av_st_dout_endofpacket -> cvo_core:av_st_din_endofpacket
	wire         scheduler_cmd_vib_valid;                   // scheduler:cmd_vib_valid -> video_in:av_st_cmd_valid
	wire  [63:0] scheduler_cmd_vib_data;                    // scheduler:cmd_vib_data -> video_in:av_st_cmd_data
	wire         scheduler_cmd_vib_ready;                   // video_in:av_st_cmd_ready -> scheduler:cmd_vib_ready
	wire         scheduler_cmd_vib_startofpacket;           // scheduler:cmd_vib_startofpacket -> video_in:av_st_cmd_startofpacket
	wire         scheduler_cmd_vib_endofpacket;             // scheduler:cmd_vib_endofpacket -> video_in:av_st_cmd_endofpacket
	wire         scheduler_cmd_mark_valid;                  // scheduler:cmd_mark_valid -> cvo_core:cmd_mark_valid
	wire  [63:0] scheduler_cmd_mark_data;                   // scheduler:cmd_mark_data -> cvo_core:cmd_mark_data
	wire         scheduler_cmd_mark_ready;                  // cvo_core:cmd_mark_ready -> scheduler:cmd_mark_ready
	wire         scheduler_cmd_mark_startofpacket;          // scheduler:cmd_mark_startofpacket -> cvo_core:cmd_mark_startofpacket
	wire         scheduler_cmd_mark_endofpacket;            // scheduler:cmd_mark_endofpacket -> cvo_core:cmd_mark_endofpacket
	wire         video_in_av_st_resp_valid;                 // video_in:av_st_resp_valid -> scheduler:resp_vib_valid
	wire  [63:0] video_in_av_st_resp_data;                  // video_in:av_st_resp_data -> scheduler:resp_vib_data
	wire         video_in_av_st_resp_ready;                 // scheduler:resp_vib_ready -> video_in:av_st_resp_ready
	wire         video_in_av_st_resp_startofpacket;         // video_in:av_st_resp_startofpacket -> scheduler:resp_vib_startofpacket
	wire         video_in_av_st_resp_endofpacket;           // video_in:av_st_resp_endofpacket -> scheduler:resp_vib_endofpacket
	wire         scheduler_cmd_mode_banks_valid;            // scheduler:cmd_mode_banks_valid -> cvo_core:cmd_mode_banks_valid
	wire  [63:0] scheduler_cmd_mode_banks_data;             // scheduler:cmd_mode_banks_data -> cvo_core:cmd_mode_banks_data
	wire         scheduler_cmd_mode_banks_ready;            // cvo_core:cmd_mode_banks_ready -> scheduler:cmd_mode_banks_ready
	wire         scheduler_cmd_mode_banks_startofpacket;    // scheduler:cmd_mode_banks_startofpacket -> cvo_core:cmd_mode_banks_startofpacket
	wire         scheduler_cmd_mode_banks_endofpacket;      // scheduler:cmd_mode_banks_endofpacket -> cvo_core:cmd_mode_banks_endofpacket
	wire         cvo_core_resp_mode_banks_valid;            // cvo_core:resp_mode_banks_valid -> scheduler:resp_mode_banks_valid
	wire  [63:0] cvo_core_resp_mode_banks_data;             // cvo_core:resp_mode_banks_data -> scheduler:resp_mode_banks_data
	wire         cvo_core_resp_mode_banks_ready;            // scheduler:resp_mode_banks_ready -> cvo_core:resp_mode_banks_ready
	wire         cvo_core_resp_mode_banks_startofpacket;    // cvo_core:resp_mode_banks_startofpacket -> scheduler:resp_mode_banks_startofpacket
	wire         cvo_core_resp_mode_banks_endofpacket;      // cvo_core:resp_mode_banks_endofpacket -> scheduler:resp_mode_banks_endofpacket
	wire         scheduler_cmd_control_slave_valid;         // scheduler:cmd_control_slave_valid -> control:av_st_cmd_valid
	wire  [63:0] scheduler_cmd_control_slave_data;          // scheduler:cmd_control_slave_data -> control:av_st_cmd_data
	wire         scheduler_cmd_control_slave_ready;         // control:av_st_cmd_ready -> scheduler:cmd_control_slave_ready
	wire         scheduler_cmd_control_slave_startofpacket; // scheduler:cmd_control_slave_startofpacket -> control:av_st_cmd_startofpacket
	wire         scheduler_cmd_control_slave_endofpacket;   // scheduler:cmd_control_slave_endofpacket -> control:av_st_cmd_endofpacket
	wire         control_av_st_resp_valid;                  // control:av_st_resp_valid -> scheduler:resp_control_slave_valid
	wire  [63:0] control_av_st_resp_data;                   // control:av_st_resp_data -> scheduler:resp_control_slave_data
	wire         control_av_st_resp_ready;                  // scheduler:resp_control_slave_ready -> control:av_st_resp_ready
	wire         control_av_st_resp_startofpacket;          // control:av_st_resp_startofpacket -> scheduler:resp_control_slave_startofpacket
	wire         control_av_st_resp_endofpacket;            // control:av_st_resp_endofpacket -> scheduler:resp_control_slave_endofpacket

	generate
		// If any of the display statements (or deliberately broken
		// instantiations) within this generate block triggers then this module
		// has been instantiated this module with a set of parameters different
		// from those it was generated for.  This will usually result in a
		// non-functioning system.
		if (BPS != 8)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					bps_check ( .error(1'b1) );
		end
		if (NUMBER_OF_COLOUR_PLANES != 3)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					number_of_colour_planes_check ( .error(1'b1) );
		end
		if (COLOUR_PLANES_ARE_IN_PARALLEL != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					colour_planes_are_in_parallel_check ( .error(1'b1) );
		end
		if (INTERLACED != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					interlaced_check ( .error(1'b1) );
		end
		if (H_ACTIVE_PIXELS != 1920)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					h_active_pixels_check ( .error(1'b1) );
		end
		if (V_ACTIVE_LINES != 1080)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					v_active_lines_check ( .error(1'b1) );
		end
		if (ACCEPT_COLOURS_IN_SEQ != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					accept_colours_in_seq_check ( .error(1'b1) );
		end
		if (FIFO_DEPTH != 1920)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					fifo_depth_check ( .error(1'b1) );
		end
		if (CLOCKS_ARE_SAME != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					clocks_are_same_check ( .error(1'b1) );
		end
		if (USE_CONTROL != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					use_control_check ( .error(1'b1) );
		end
		if (NO_OF_MODES != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					no_of_modes_check ( .error(1'b1) );
		end
		if (THRESHOLD != 1919)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					threshold_check ( .error(1'b1) );
		end
		if (STD_WIDTH != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					std_width_check ( .error(1'b1) );
		end
		if (GENERATE_SYNC != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					generate_sync_check ( .error(1'b1) );
		end
		if (LOW_LATENCY != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					low_latency_check ( .error(1'b1) );
		end
		if (USE_EMBEDDED_SYNCS != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					use_embedded_syncs_check ( .error(1'b1) );
		end
		if (AP_LINE != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					ap_line_check ( .error(1'b1) );
		end
		if (V_BLANK != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					v_blank_check ( .error(1'b1) );
		end
		if (H_BLANK != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					h_blank_check ( .error(1'b1) );
		end
		if (H_SYNC_LENGTH != 40)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					h_sync_length_check ( .error(1'b1) );
		end
		if (H_FRONT_PORCH != 110)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					h_front_porch_check ( .error(1'b1) );
		end
		if (H_BACK_PORCH != 220)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					h_back_porch_check ( .error(1'b1) );
		end
		if (V_SYNC_LENGTH != 5)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					v_sync_length_check ( .error(1'b1) );
		end
		if (V_FRONT_PORCH != 5)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					v_front_porch_check ( .error(1'b1) );
		end
		if (V_BACK_PORCH != 20)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					v_back_porch_check ( .error(1'b1) );
		end
		if (F_RISING_EDGE != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					f_rising_edge_check ( .error(1'b1) );
		end
		if (F_FALLING_EDGE != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					f_falling_edge_check ( .error(1'b1) );
		end
		if (FIELD0_V_RISING_EDGE != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					field0_v_rising_edge_check ( .error(1'b1) );
		end
		if (FIELD0_V_BLANK != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					field0_v_blank_check ( .error(1'b1) );
		end
		if (FIELD0_V_SYNC_LENGTH != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					field0_v_sync_length_check ( .error(1'b1) );
		end
		if (FIELD0_V_FRONT_PORCH != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					field0_v_front_porch_check ( .error(1'b1) );
		end
		if (FIELD0_V_BACK_PORCH != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					field0_v_back_porch_check ( .error(1'b1) );
		end
		if (ANC_LINE != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					anc_line_check ( .error(1'b1) );
		end
		if (FIELD0_ANC_LINE != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					field0_anc_line_check ( .error(1'b1) );
		end
		if (PIXELS_IN_PARALLEL != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					pixels_in_parallel_check ( .error(1'b1) );
		end
		if (SRC_WIDTH != 8)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					src_width_check ( .error(1'b1) );
		end
		if (DST_WIDTH != 8)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					dst_width_check ( .error(1'b1) );
		end
		if (CONTEXT_WIDTH != 8)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					context_width_check ( .error(1'b1) );
		end
		if (TASK_WIDTH != 8)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					task_width_check ( .error(1'b1) );
		end
	endgenerate

	pattern_gen_alt_vip_cl_cvo_0_video_in video_in (
		.main_clock_clk              (main_clock_clk),                    //    main_clock.clk
		.main_reset_reset            (main_reset_reset),                  //    main_reset.reset
		.av_st_vid_din_data          (din_data),                          // av_st_vid_din.data
		.av_st_vid_din_valid         (din_valid),                         //              .valid
		.av_st_vid_din_startofpacket (din_startofpacket),                 //              .startofpacket
		.av_st_vid_din_endofpacket   (din_endofpacket),                   //              .endofpacket
		.av_st_vid_din_ready         (din_ready),                         //              .ready
		.av_st_cmd_valid             (scheduler_cmd_vib_valid),           //     av_st_cmd.valid
		.av_st_cmd_startofpacket     (scheduler_cmd_vib_startofpacket),   //              .startofpacket
		.av_st_cmd_endofpacket       (scheduler_cmd_vib_endofpacket),     //              .endofpacket
		.av_st_cmd_data              (scheduler_cmd_vib_data),            //              .data
		.av_st_cmd_ready             (scheduler_cmd_vib_ready),           //              .ready
		.av_st_resp_valid            (video_in_av_st_resp_valid),         //    av_st_resp.valid
		.av_st_resp_startofpacket    (video_in_av_st_resp_startofpacket), //              .startofpacket
		.av_st_resp_endofpacket      (video_in_av_st_resp_endofpacket),   //              .endofpacket
		.av_st_resp_data             (video_in_av_st_resp_data),          //              .data
		.av_st_resp_ready            (video_in_av_st_resp_ready),         //              .ready
		.av_st_dout_valid            (video_in_av_st_dout_valid),         //    av_st_dout.valid
		.av_st_dout_startofpacket    (video_in_av_st_dout_startofpacket), //              .startofpacket
		.av_st_dout_endofpacket      (video_in_av_st_dout_endofpacket),   //              .endofpacket
		.av_st_dout_data             (video_in_av_st_dout_data),          //              .data
		.av_st_dout_ready            (video_in_av_st_dout_ready)          //              .ready
	);

	alt_vip_cvo_scheduler #(
		.SRC_WIDTH     (8),
		.DST_WIDTH     (8),
		.CONTEXT_WIDTH (8),
		.TASK_WIDTH    (8),
		.USE_CONTROL   (1)
	) scheduler (
		.clock                            (main_clock_clk),                            //         main_clock.clk
		.reset                            (main_reset_reset),                          //         main_reset.reset
		.cmd_vib_valid                    (scheduler_cmd_vib_valid),                   //            cmd_vib.valid
		.cmd_vib_startofpacket            (scheduler_cmd_vib_startofpacket),           //                   .startofpacket
		.cmd_vib_endofpacket              (scheduler_cmd_vib_endofpacket),             //                   .endofpacket
		.cmd_vib_data                     (scheduler_cmd_vib_data),                    //                   .data
		.cmd_vib_ready                    (scheduler_cmd_vib_ready),                   //                   .ready
		.cmd_mark_valid                   (scheduler_cmd_mark_valid),                  //           cmd_mark.valid
		.cmd_mark_startofpacket           (scheduler_cmd_mark_startofpacket),          //                   .startofpacket
		.cmd_mark_endofpacket             (scheduler_cmd_mark_endofpacket),            //                   .endofpacket
		.cmd_mark_data                    (scheduler_cmd_mark_data),                   //                   .data
		.cmd_mark_ready                   (scheduler_cmd_mark_ready),                  //                   .ready
		.cmd_mode_banks_valid             (scheduler_cmd_mode_banks_valid),            //     cmd_mode_banks.valid
		.cmd_mode_banks_startofpacket     (scheduler_cmd_mode_banks_startofpacket),    //                   .startofpacket
		.cmd_mode_banks_endofpacket       (scheduler_cmd_mode_banks_endofpacket),      //                   .endofpacket
		.cmd_mode_banks_data              (scheduler_cmd_mode_banks_data),             //                   .data
		.cmd_mode_banks_ready             (scheduler_cmd_mode_banks_ready),            //                   .ready
		.resp_vib_valid                   (video_in_av_st_resp_valid),                 //           resp_vib.valid
		.resp_vib_startofpacket           (video_in_av_st_resp_startofpacket),         //                   .startofpacket
		.resp_vib_endofpacket             (video_in_av_st_resp_endofpacket),           //                   .endofpacket
		.resp_vib_data                    (video_in_av_st_resp_data),                  //                   .data
		.resp_vib_ready                   (video_in_av_st_resp_ready),                 //                   .ready
		.resp_mode_banks_valid            (cvo_core_resp_mode_banks_valid),            //    resp_mode_banks.valid
		.resp_mode_banks_startofpacket    (cvo_core_resp_mode_banks_startofpacket),    //                   .startofpacket
		.resp_mode_banks_endofpacket      (cvo_core_resp_mode_banks_endofpacket),      //                   .endofpacket
		.resp_mode_banks_data             (cvo_core_resp_mode_banks_data),             //                   .data
		.resp_mode_banks_ready            (cvo_core_resp_mode_banks_ready),            //                   .ready
		.cmd_control_slave_valid          (scheduler_cmd_control_slave_valid),         //  cmd_control_slave.valid
		.cmd_control_slave_startofpacket  (scheduler_cmd_control_slave_startofpacket), //                   .startofpacket
		.cmd_control_slave_endofpacket    (scheduler_cmd_control_slave_endofpacket),   //                   .endofpacket
		.cmd_control_slave_data           (scheduler_cmd_control_slave_data),          //                   .data
		.cmd_control_slave_ready          (scheduler_cmd_control_slave_ready),         //                   .ready
		.resp_control_slave_valid         (control_av_st_resp_valid),                  // resp_control_slave.valid
		.resp_control_slave_startofpacket (control_av_st_resp_startofpacket),          //                   .startofpacket
		.resp_control_slave_endofpacket   (control_av_st_resp_endofpacket),            //                   .endofpacket
		.resp_control_slave_data          (control_av_st_resp_data),                   //                   .data
		.resp_control_slave_ready         (control_av_st_resp_ready)                   //                   .ready
	);

	alt_vip_pip_sop_realign #(
		.PIXEL_WIDTH        (24),
		.PIXELS_IN_PARALLEL (1),
		.PIPELINE_READY     (0),
		.SRC_WIDTH          (8),
		.DST_WIDTH          (8),
		.CONTEXT_WIDTH      (8),
		.TASK_WIDTH         (8)
	) sop_align (
		.clock                    (main_clock_clk),                     // main_clock.clk
		.reset                    (main_reset_reset),                   // main_reset.reset
		.av_st_din_valid          (video_in_av_st_dout_valid),          //  av_st_din.valid
		.av_st_din_startofpacket  (video_in_av_st_dout_startofpacket),  //           .startofpacket
		.av_st_din_endofpacket    (video_in_av_st_dout_endofpacket),    //           .endofpacket
		.av_st_din_data           (video_in_av_st_dout_data),           //           .data
		.av_st_din_ready          (video_in_av_st_dout_ready),          //           .ready
		.av_st_dout_valid         (sop_align_av_st_dout_valid),         // av_st_dout.valid
		.av_st_dout_startofpacket (sop_align_av_st_dout_startofpacket), //           .startofpacket
		.av_st_dout_endofpacket   (sop_align_av_st_dout_endofpacket),   //           .endofpacket
		.av_st_dout_data          (sop_align_av_st_dout_data),          //           .data
		.av_st_dout_ready         (sop_align_av_st_dout_ready)          //           .ready
	);

	alt_vip_cvo_core #(
		.NUMBER_OF_COLOUR_PLANES       (3),
		.COLOUR_PLANES_ARE_IN_PARALLEL (1),
		.BPS                           (8),
		.INTERLACED                    (0),
		.H_ACTIVE_PIXELS               (1920),
		.V_ACTIVE_LINES                (1080),
		.ACCEPT_COLOURS_IN_SEQ         (0),
		.FIFO_DEPTH                    (1920),
		.CLOCKS_ARE_SAME               (1),
		.USE_CONTROL                   (1),
		.NO_OF_MODES                   (1),
		.THRESHOLD                     (1919),
		.STD_WIDTH                     (1),
		.GENERATE_SYNC                 (0),
		.USE_EMBEDDED_SYNCS            (0),
		.AP_LINE                       (0),
		.V_BLANK                       (0),
		.H_BLANK                       (0),
		.H_SYNC_LENGTH                 (40),
		.H_FRONT_PORCH                 (110),
		.H_BACK_PORCH                  (220),
		.V_SYNC_LENGTH                 (5),
		.V_FRONT_PORCH                 (5),
		.V_BACK_PORCH                  (20),
		.F_RISING_EDGE                 (0),
		.F_FALLING_EDGE                (0),
		.FIELD0_V_RISING_EDGE          (0),
		.FIELD0_V_BLANK                (0),
		.FIELD0_V_SYNC_LENGTH          (0),
		.FIELD0_V_FRONT_PORCH          (0),
		.FIELD0_V_BACK_PORCH           (0),
		.ANC_LINE                      (0),
		.FIELD0_ANC_LINE               (0),
		.PIXELS_IN_PARALLEL            (1),
		.UHD_MODE                      (1),
		.LOW_LATENCY                   (0),
		.SRC_WIDTH                     (8),
		.DST_WIDTH                     (8),
		.CONTEXT_WIDTH                 (8),
		.TASK_WIDTH                    (8)
	) cvo_core (
		.is_clk                        (main_clock_clk),                         //        main_clock.clk
		.rst                           (main_reset_reset),                       //        main_reset.reset
		.cmd_mark_valid                (scheduler_cmd_mark_valid),               //          cmd_mark.valid
		.cmd_mark_startofpacket        (scheduler_cmd_mark_startofpacket),       //                  .startofpacket
		.cmd_mark_endofpacket          (scheduler_cmd_mark_endofpacket),         //                  .endofpacket
		.cmd_mark_data                 (scheduler_cmd_mark_data),                //                  .data
		.cmd_mark_ready                (scheduler_cmd_mark_ready),               //                  .ready
		.cmd_mode_banks_valid          (scheduler_cmd_mode_banks_valid),         //    cmd_mode_banks.valid
		.cmd_mode_banks_startofpacket  (scheduler_cmd_mode_banks_startofpacket), //                  .startofpacket
		.cmd_mode_banks_endofpacket    (scheduler_cmd_mode_banks_endofpacket),   //                  .endofpacket
		.cmd_mode_banks_data           (scheduler_cmd_mode_banks_data),          //                  .data
		.cmd_mode_banks_ready          (scheduler_cmd_mode_banks_ready),         //                  .ready
		.resp_mode_banks_valid         (cvo_core_resp_mode_banks_valid),         //   resp_mode_banks.valid
		.resp_mode_banks_startofpacket (cvo_core_resp_mode_banks_startofpacket), //                  .startofpacket
		.resp_mode_banks_endofpacket   (cvo_core_resp_mode_banks_endofpacket),   //                  .endofpacket
		.resp_mode_banks_data          (cvo_core_resp_mode_banks_data),          //                  .data
		.resp_mode_banks_ready         (cvo_core_resp_mode_banks_ready),         //                  .ready
		.status_update_int             (status_update_irq_irq),                  // status_update_irq.irq
		.av_st_din_valid               (sop_align_av_st_dout_valid),             //         av_st_din.valid
		.av_st_din_startofpacket       (sop_align_av_st_dout_startofpacket),     //                  .startofpacket
		.av_st_din_endofpacket         (sop_align_av_st_dout_endofpacket),       //                  .endofpacket
		.av_st_din_data                (sop_align_av_st_dout_data),              //                  .data
		.av_st_din_ready               (sop_align_av_st_dout_ready),             //                  .ready
		.vid_data                      (clocked_video_vid_data),                 //     clocked_video.vid_data
		.underflow                     (clocked_video_underflow),                //                  .underflow
		.vid_mode_change               (clocked_video_vid_mode_change),          //                  .vid_mode_change
		.vid_std                       (clocked_video_vid_std),                  //                  .vid_std
		.vid_datavalid                 (clocked_video_vid_datavalid),            //                  .vid_datavalid
		.vid_v_sync                    (clocked_video_vid_v_sync),               //                  .vid_v_sync
		.vid_h_sync                    (clocked_video_vid_h_sync),               //                  .vid_h_sync
		.vid_f                         (clocked_video_vid_f),                    //                  .vid_f
		.vid_h                         (clocked_video_vid_h),                    //                  .vid_h
		.vid_v                         (clocked_video_vid_v)                     //                  .vid_v
	);

	alt_vip_control_slave #(
		.NUM_READ_REGISTERS             (1),
		.NUM_TRIGGER_REGISTERS          (27),
		.NUM_BLOCKING_TRIGGER_REGISTERS (0),
		.NUM_RW_REGISTERS               (0),
		.NUM_INTERRUPTS                 (0),
		.MM_CONTROL_REG_BYTES           (1),
		.MM_READ_REG_BYTES              (4),
		.MM_TRIGGER_REG_BYTES           (4),
		.MM_RW_REG_BYTES                (4),
		.MM_ADDR_WIDTH                  (8),
		.DATA_INPUT                     (0),
		.DATA_OUTPUT                    (0),
		.FAST_REGISTER_UPDATES          (0),
		.USE_MEMORY                     (0),
		.PIPELINE_READ                  (0),
		.PIPELINE_RESPONSE              (0),
		.PIPELINE_DATA                  (0),
		.SRC_WIDTH                      (8),
		.DST_WIDTH                      (8),
		.CONTEXT_WIDTH                  (8),
		.TASK_WIDTH                     (8),
		.RESP_SOURCE                    (1),
		.RESP_DEST                      (1),
		.RESP_CONTEXT                   (1),
		.DOUT_SOURCE                    (1),
		.USE_16BIT_ADDRESSING           (0)
	) control (
		.clock                       (main_clock_clk),                            //    main_clock.clk
		.reset                       (main_reset_reset),                          //    main_reset.reset
		.av_mm_control_address       (control_address),                           // av_mm_control.address
		.av_mm_control_byteenable    (control_byteenable),                        //              .byteenable
		.av_mm_control_write         (control_write),                             //              .write
		.av_mm_control_writedata     (control_writedata),                         //              .writedata
		.av_mm_control_read          (control_read),                              //              .read
		.av_mm_control_readdata      (control_readdata),                          //              .readdata
		.av_mm_control_readdatavalid (control_readdatavalid),                     //              .readdatavalid
		.av_mm_control_waitrequest   (control_waitrequest),                       //              .waitrequest
		.av_st_cmd_valid             (scheduler_cmd_control_slave_valid),         //     av_st_cmd.valid
		.av_st_cmd_startofpacket     (scheduler_cmd_control_slave_startofpacket), //              .startofpacket
		.av_st_cmd_endofpacket       (scheduler_cmd_control_slave_endofpacket),   //              .endofpacket
		.av_st_cmd_data              (scheduler_cmd_control_slave_data),          //              .data
		.av_st_cmd_ready             (scheduler_cmd_control_slave_ready),         //              .ready
		.av_st_resp_valid            (control_av_st_resp_valid),                  //    av_st_resp.valid
		.av_st_resp_startofpacket    (control_av_st_resp_startofpacket),          //              .startofpacket
		.av_st_resp_endofpacket      (control_av_st_resp_endofpacket),            //              .endofpacket
		.av_st_resp_data             (control_av_st_resp_data),                   //              .data
		.av_st_resp_ready            (control_av_st_resp_ready)                   //              .ready
	);

endmodule
