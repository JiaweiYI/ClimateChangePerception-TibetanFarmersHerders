import pandas as pd
import numpy as np

# default folder
main_dir = r"D:\research\TPerception\TPerception-Tibet"


def fig_data():
    # input data
    infile = main_dir + r"\data\out\tperception_tibet.csv"
    df = pd.read_csv(infile)[['y1_c', 'y2_c', 'y7_c', 'y8_c', 'y10_c', 'y11_c',
                              'x_gender', 'x_age', 'x_pincome', 'x_edu',
                              'elev', 'x_dist2county', 'x_credit', 'x_wateracc', 'x_mediabelief',
                              # 'p_flood', 'p_drought', 'p_blizzard', 'p_hail',
                              'z_prefecture', 'z_county']]
    infile = main_dir + r"\data\out\climate.csv"
    df_c = pd.read_csv(infile)[['station', 'T_30a', 'Tt_30a', 'P_30a', 'Pt_30a', 'TXDt_30a', 'PTDt_30a']].set_index(
        'station')

    # statistics
    num_of_respondent = df.y1_c.count()
    num_of_prefecture = df.z_prefecture.unique().size
    num_of_county = df.z_county.unique().size
    num_of_station = df_c.index.unique().size
    age_mean = df.x_age.mean()
    age_std = df.x_age.std()
    female_sample = (df.x_gender == '女').sum()
    gender_sample = df.x_gender.count()
    edu_sample = df.x_edu.count()
    elementary_sample = (df.x_edu == 'elementary').sum()
    income_mean = df.x_pincome.mean()
    income_std = df.x_pincome.std()
    credit_yes = (df.x_credit == 'yes').sum()
    credit_sample = df.x_credit.count()
    elev_mean = df.elev.mean()
    elev_std = df.elev.std()
    remoteness_mean = df.x_dist2county.mean()
    remoteness_std = df.x_dist2county.std()
    wateracc_yes = (df.x_wateracc == 'good').sum()
    wateracc_sample = df.x_wateracc.count()
    mediatrust_yes = (df.x_mediabelief == 'trust').sum()
    mediatrust_sample = df.x_mediabelief.count()
    # disaster_count_mean = df[['p_flood', 'p_drought', 'p_blizzard', 'p_hail']].drop_duplicates().mean().tolist()
    # disaster_count_std = df[['p_flood', 'p_drought', 'p_blizzard', 'p_hail']].drop_duplicates().std().tolist()
    tem_perception_sample = df.groupby('y1_c').count()['z_prefecture']
    pre_perception_sample = df.groupby('y2_c').count()['z_prefecture']
    adaptive_capacity_sample = df.groupby('y7_c').count()['z_prefecture']
    climate_impact_sample = df.groupby('y8_c').count()['z_prefecture']
    mitigation_effect_sample = df.groupby('y10_c').count()['z_prefecture']
    future_climate_sample = df.groupby('y11_c').count()['z_prefecture']
    climate_var = df_c.mean().values.tolist() + df_c.std().values.tolist()

    # save data
    out = [num_of_respondent, num_of_prefecture, num_of_county, num_of_station,
           age_mean, age_std, female_sample, gender_sample, elementary_sample, edu_sample,
           income_mean, income_std, credit_yes, credit_sample, elev_mean, elev_std,
           remoteness_mean, remoteness_std, wateracc_yes, wateracc_sample, mediatrust_yes, mediatrust_sample,
           tem_perception_sample['not change'], tem_perception_sample['warming'], tem_perception_sample['cooling'],
           tem_perception_sample['unknown'],
           pre_perception_sample['not change'], pre_perception_sample['increased'], pre_perception_sample['decreased'],
           pre_perception_sample['unknown'],
           climate_impact_sample['huge'] + climate_impact_sample['great'], climate_impact_sample['average'],
           climate_impact_sample['little'] + climate_impact_sample['very little'],
           adaptive_capacity_sample['very good'] + adaptive_capacity_sample['good'],
           adaptive_capacity_sample['average'],
           adaptive_capacity_sample['weak'] + adaptive_capacity_sample['very weak'],
           mitigation_effect_sample['huge'] + mitigation_effect_sample['great'], mitigation_effect_sample['average'],
           mitigation_effect_sample['little'] + mitigation_effect_sample['very little'],
           future_climate_sample['become better'], future_climate_sample['become worse']] + climate_var
    colnames = ['respondents', 'prefecture', 'county', 'station',
                'age_mean', 'age_std', 'female_sample', 'gender_sample', 'elementary_sample', 'edu_sample',
                'income_mean', 'income_std', 'credit_yes', 'credit_sample', 'elev_mean', 'elev_std',
                'remoteness_mean', 'remoteness_std', 'wateracc_yes', 'wateracc_sample', 'mediatrust_yes', 'mediatrust_sample',
                'tem_nochange', 'tem_increase', 'tem_decrease', 'tem_unknown',
                'pre_nochange', 'pre_increase', 'pre_decrease', 'pre_unknown',
                'climate_impact_GREAT', 'climate_impact_AVERAGE', 'climate_impact_LITTLE',
                'adaptive_capacity_GOOD', 'adaptive_capacity_AVERAGE', 'adaptive_capacity_WEAK',
                'mitigation_effect_GREAT', 'mitigation_effect_AVERAGE', 'mitigation_effect_LITTLE',
                'future_climate_BETTER', 'future_climate_WORSE',
                'T30_mean', 'Tt30_mean', 'P30_mean', 'Pt30_mean', 'TXDt30_mean', 'PTDt30_mean',
                'T30_std', 'Tt30_std', 'P30_std', 'Pt30_std', 'TXDt30_std', 'PTDt30_std']
    df_out = pd.DataFrame(out).T
    df_out.columns = colnames
    outfile = main_dir + r"\code\figure\fig1\summary_data_socioeconomic_climate_perception.csv"
    df_out.transpose().to_csv(outfile)
