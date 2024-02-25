import pandas as pd
import seaborn as sns
import numpy as np
import matplotlib.pyplot as plt
import matplotlib

plt.rcParams['figure.dpi'] = 300
plt.rcParams['font.family'] = 'Arial'
plt.rcParams.update({'font.size': 8})
sns.set_style("ticks")

# default data folder
main_dir = r"D:\research\TPerception\TPerception-Tibet"


def fig_tem_data():
    # individual models
    infile = main_dir + r"\code\figure\fig4\Bayesian\temperature\BI_effect.csv"
    df = pd.read_csv(infile)
    df.columns = ['predictor', 'lower', 'median', 'upper']
    df_r2 = df.round(2)
    df_r2['effect'] = 'x'
    df_r2.loc[df_r2['lower'] > 0, 'effect'] = '+'
    df_r2.loc[df_r2['upper'] < 0, 'effect'] = '-'
    df_r2_c = df_r2.groupby(['predictor', 'effect']).count()[['median']].reset_index()
    df_r2_c = df_r2_c.pivot(index='predictor', columns='effect', values='median').fillna(0)
    outfile = main_dir + r"\code\figure\fig4\Bayesian\temperature\BI_effect_stat.csv"
    df_r2_c.to_csv(outfile, encoding='utf_8_sig')

    df_m = df.groupby('predictor').mean().round(2)
    df_m['effect'] = 'x'
    df_m.loc[df_m['lower'] > 0, 'effect'] = '+'
    df_m.loc[df_m['upper'] < 0, 'effect'] = '-'
    scs_cols = ['scale(elev)', 'x_gender女', 'scale(x_age)', 'x_edumiddle',
                'scale(x_pincome)', 'scale(x_dist2county)', 'scale(x_farminc)',
                'x_credityes', 'x_mediabeliefnot trust',
                'x_mediabelieftrust', 'x_wateraccgood', 'x_wateraccpoor']
    cli_cols = ['k_T_5a', 'k_T_10a', 'k_T_20a', 'k_T_30a',
                'k_Tt_5a', 'k_Tt_10a', 'k_Tt_20a', 'k_Tt_30a',
                'k_TXDt_5a', 'k_TXDt_10a', 'k_TXDt_20a', 'k_TXDt_30a',
                'k_P_5a', 'k_P_10a', 'k_P_20a', 'k_P_30a',
                'k_Pt_5a', 'k_Pt_10a', 'k_Pt_20a', 'k_Pt_30a',
                'k_PTDt_5a', 'k_PTDt_10a', 'k_PTDt_20a', 'k_PTDt_30a']
    df_scs = df_m.loc[scs_cols].copy()
    df_cli = df_m.loc[cli_cols].copy()

    # multi-level models
    infile = main_dir + r"\code\figure\fig4\Bayesian\temperature\BP_effect.csv"
    df_BP = pd.read_csv(infile)
    df_BP.columns = ['predictor', 'lower', 'median', 'upper']
    df_BP_r2 = df_BP.round(2)
    df_BP_r2['effect'] = 'x'
    df_BP_r2.loc[df_BP_r2['lower'] > 0, 'effect'] = '+'
    df_BP_r2.loc[df_BP_r2['upper'] < 0, 'effect'] = '-'
    df_BP_r2_c = df_BP_r2.groupby(['predictor', 'effect']).count()[['median']].reset_index()
    df_BP_r2_c = df_BP_r2_c.pivot(index='predictor', columns='effect', values='median').fillna(0)
    outfile = main_dir + r"\code\figure\fig4\Bayesian\temperature\BP_effect_stat.csv"
    df_BP_r2_c.to_csv(outfile, encoding='utf_8_sig')

    df_BP_m = df_BP.groupby('predictor').mean().round(2)
    df_BP_m['effect'] = 'x'
    df_BP_m.loc[df_BP_m['lower'] > 0, 'effect'] = '+'
    df_BP_m.loc[df_BP_m['upper'] < 0, 'effect'] = '-'
    disaster_cols = ['p_drought', 'p_flood', 'p_blizzard', 'p_hail']
    df_disaster = df_BP_m.loc[disaster_cols].copy()
    df_out1 = pd.concat([df_scs, df_disaster])
    df_out2 = df_cli
    outfile = main_dir + r"/code/figure/fig4/fig4a_tem_data.csv"
    df_out1.to_csv(outfile, encoding='utf_8_sig')
    outfile = main_dir + r"/code/figure/fig4/fig4b_tem_data.csv"
    df_out2.to_csv(outfile, encoding='utf_8_sig')


def response_summary_table():
    # BI
    models = ['BI', 'BL','BP']
    responses = ['temperature', 'precipitation', 'mitigation', 'impact', 'adaptation', 'future']
    for m in models:
        response_summary_table = pd.DataFrame([], columns=responses)
        response_count_table = pd.DataFrame([], columns=responses)
        for res in responses:
            infile = main_dir + r"\code\figure\fig4\Bayesian\\" + res + "\\" + m + "_effect.csv"
            df = pd.read_csv(infile)
            df.columns = ['predictor', 'lower', 'median', 'upper']
            df_r2 = df.round(2)
            df_r2['effect'] = 'x'
            df_r2.loc[df_r2['lower'] > 0, 'effect'] = '+'
            df_r2.loc[df_r2['upper'] < 0, 'effect'] = '-'
            df_r2_c = df_r2.groupby(['predictor', 'effect']).count()[['median']].reset_index()
            df_r2_c = df_r2_c.pivot(index='predictor', columns='effect', values='median').fillna(0)
            df_sign = df_r2_c.idxmax(axis=1)
            df_count = df_r2_c.max(axis=1)
            response_summary_table.loc[:, res] = df_sign
            response_count_table.loc[:, res] = df_count
        outfile = main_dir + r"\code\figure\fig4\Bayesian\summary\\" + "\\" + m + "_effect.csv"
        response_summary_table.to_csv(outfile, encoding='utf_8_sig')
        outfile = main_dir + r"\code\figure\fig4\Bayesian\summary\\" + "\\" + m + "_effect_stat.csv"
        response_count_table.to_csv(outfile, encoding='utf_8_sig')


def fig_tem_plot():
    # input data
    infile = main_dir + r"/code/figure/fig4/fig4a_tem_data.csv"
    df1 = pd.read_csv(infile)
    df1 = df1.iloc[::-1]
    infile = main_dir + r"/code/figure/fig4/fig4b_tem_data.csv"
    df2 = pd.read_csv(infile)
    df2 = df2.iloc[::-1]

    red = '#FF33CC'
    blue = '#0066FF'
    grey = '#AFABAB'

    # each subplot consists of two split parts
    f = plt.figure(figsize=(7 / 2.54, 12 / 2.54))
    gs = matplotlib.gridspec.GridSpec(1, 2, width_ratios=[1, 4])

    # subplot a
    ax1 = plt.subplot(gs[0])
    ax2 = plt.subplot(gs[1], sharey=ax1)
    ax1.plot(df1['median'], df1['predictor'],
             ls='', marker='o', markersize=6,
             markeredgecolor='none', markerfacecolor=grey)
    ax2.plot(df1['median'], df1['predictor'],
             ls='', marker='o', markersize=6,
             markeredgecolor='none', markerfacecolor=grey)
    # positive effects
    df1c = df1[df1.effect == '+']
    ax1.plot(df1c['median'], df1c['predictor'],
             ls='', marker='o', markersize=6,
             markeredgecolor='none', markerfacecolor=red)
    ax2.plot(df1c['median'], df1c['predictor'],
             ls='', marker='o', markersize=6,
             markeredgecolor='none', markerfacecolor=red)
    # negative effects
    df1c = df1[df1.effect == '-']
    ax1.plot(df1c['median'], df1c['predictor'],
             ls='', marker='o', markersize=6,
             markeredgecolor='none', markerfacecolor=blue)
    ax2.plot(df1c['median'], df1c['predictor'],
             ls='', marker='o', markersize=6,
             markeredgecolor='none', markerfacecolor=blue)
    # credit interval bars
    ax1.hlines(y=df1['predictor'], xmin=df1['lower'], xmax=df1['upper'],
               ls='-', linewidth=1)
    ax2.hlines(y=df1['predictor'], xmin=df1['lower'], xmax=df1['upper'],
               ls='-', linewidth=1)
    # reference line
    ax2.axvline(x=0, ls='--', color='k', linewidth=1)

    # figure parameters
    ax1.set_xlim(-10, -1.2)
    ax2.set_xlim(-1.2, 1)

    ax1.spines['right'].set_visible(False)
    ax1.spines['top'].set_visible(False)
    ax2.spines['right'].set_visible(False)
    ax2.spines['top'].set_visible(False)

    ax2.get_yaxis().set_visible(False)
    ax1.set_yticklabels([])
    ax2.spines['left'].set_visible(False)

    d = .5  # proportion of vertical to horizontal extent of the slanted line
    kwargs = dict(marker=[(-1, -d), (1, d)], markersize=12,
                  linestyle="none", color='k', mec='k', mew=1, clip_on=False)
    ax1.plot([1], [0], transform=ax1.transAxes, **kwargs)
    ax2.plot([0], [0], transform=ax2.transAxes, **kwargs)

    f.tight_layout()
    outfile = main_dir + r"/code/figure/fig4/fig4a_tem.png"
    plt.savefig(outfile, dpi=300)

    # subplot b
    f = plt.figure(figsize=(7 / 2.54, 12 / 2.54))

    ax3 = plt.subplot()
    ax3.plot(df2['median'], df2['predictor'],
             ls='', marker='o', markersize=6,
             markeredgecolor='none', markerfacecolor=grey)
    # positive effects
    df2c = df2[df2.effect == '+']
    ax3.plot(df2c['median'], df2c['predictor'],
             ls='', marker='o', markersize=6,
             markeredgecolor='none', markerfacecolor=red)
    # negative effects
    df2c = df2[df2.effect == '-']
    ax3.plot(df2c['median'], df2c['predictor'],
             ls='', marker='o', markersize=6,
             markeredgecolor='none', markerfacecolor=blue)
    # credit interval bars
    ax3.hlines(y=df2['predictor'], xmin=df2['lower'], xmax=df2['upper'],
               ls='-', linewidth=1)
    # reference line
    ax3.axvline(x=0, ls='--', color='k', linewidth=1)

    # figure parameters
    ax3.set_xlim(-1, 1)

    ax3.spines['right'].set_visible(False)
    ax3.spines['top'].set_visible(False)

    ax3.set_yticklabels([])

    f.tight_layout()
    outfile = main_dir + r"/code/figure/fig4/fig4b_tem.png"
    plt.savefig(outfile, dpi=300)
